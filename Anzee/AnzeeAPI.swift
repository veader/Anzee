//
//  AnzeeAPI.swift
//  Anzee
//
//  Created by Shawn Veader on 4/2/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

enum APIError: Error {
    case jsonParsingError(err: String)
    case requestError(err: Error)
    case requestTimeout
    case apiInvalidURL
    case apiError(response: APIErrorResponse)
    case jsonMissingData
    case jsonMissingResponseData
    case jsonBoom
}

enum HTTPVerb: String {
    case get = "GET"
    case post = "POST"
}

public typealias JSONHash = [String:Any]

struct AnzeeAPI {

    /// The API token to use to authenticate to Mailchimp API
    /// Documentation: https://developer.mailchimp.com/documentation/mailchimp/guides/get-started-with-mailchimp-api-3/#authentication
    ///
    /// - Note: The token should take the form of 'abcd...xyz-us0'
    var token: String?

    /// "Base" token portion of the API token
    private var baseToken: String? {
        guard let tok = token?.split(separator: "-").first else { return nil }
        return String(tok)
    }

    /// Datacenter portion of the API token
    private var datacenter: String? {
        guard let dc = token?.split(separator: "-").last else { return nil }
        return String(dc)
    }

    // ----------------------------------------------------------------
    // MARK: - Request Processing

    /// Process the given APIRequest and pass data back.
    ///
    /// - Parameters:
    ///     - request: A request that conforms to the `APIRequest` protocol
    ///
    /// - Returns: `NSURLSessionDataTask?` optional data task
    @discardableResult
    public func process(request: APIRequest) -> URLSessionDataTask? {
        guard let urlRequest = buildURLRequest(for: request) else {
            request.requestComplete(data: nil, error: .apiInvalidURL)
            return nil
        }

        switch request.httpVerb() {
        case .get:
            return getJSON(request: urlRequest) { data, error in
                request.requestComplete(data: data, error: error)
            }
        case .post:
            // TODO: set these from request
            let params = [String: String]()
            return postJSON(request: urlRequest, params: params) { data, error in
                request.requestComplete(data: data, error: error)
            }
        }
    }


    // ----------------------------------------------------------------
    // MARK: - Wrappers

    /// Execute a GET request for a JSON response. Uses a `URLSessionDataTask` to do the work.
    ///
    /// - Parameters:
    ///     - request: `URLRequest` describing request
    ///     - completionBlock: block to call once the task is complete
    /// - Returns: `URLSessionDataTask` reference to task doing work
    fileprivate func getJSON(request: URLRequest, completionBlock: @escaping (Data?, APIError?) -> Void) -> URLSessionDataTask {
        let urlSession = session()
        let task = urlSession.dataTask(with: request) { (data, response, responseError) -> Void in
            if let err = responseError as NSError? {
                if err.domain == NSURLErrorDomain && err.code == -1001 {
                    completionBlock(nil, .requestTimeout)
                } else {
                    completionBlock(nil, .requestError(err: err))
                }
            } else if let jsonData = data {
                completionBlock(jsonData, nil)
            } else {
                completionBlock(nil, .jsonMissingData)
            }
        }

        task.resume()
        return task
    }

    /// Execute a POST request. Uses a `URLSessionDataTask` to do the work.
    ///
    /// - Parameters:
    ///     - request: `URLRequest` describing request
    ///     - params: `[String: String]` dictionary of parameters to encode as JSON in body of requst
    ///     - completionBlock: block to call once the task is complete
    /// - Returns: `URLSessionDataTask` reference to task doing work
    fileprivate func postJSON(request: URLRequest, params: [String: String], completionBlock: @escaping (Data?, APIError?) -> Void) -> URLSessionDataTask? {
        var mutableRequest = request

        // add any POST body params
        do {
            mutableRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            return nil
        }

        let urlSession = session()
        let task = urlSession.dataTask(with: mutableRequest) { (data, response, responseError) in
            if let err = responseError as NSError? {
                if err.domain == NSURLErrorDomain && err.code == -1001 {
                    completionBlock(nil, .requestTimeout)
                } else {
                    completionBlock(nil, .requestError(err: err))
                }
            } else if let jsonData = data {
                completionBlock(jsonData, nil)
            } else {
                completionBlock(nil, .jsonMissingData)
            }
        }

        task.resume()
        return task
    }


    // ----------------------------------------------------------------
    // MARK: - URL Methods

    /// Build URLRequest from values of our APIRequest.
    ///
    /// Constructs with full URL, HTTP verb, auth headers, etc.
    ///
    /// - Parameters:
    ///     - request: `APIRequest` request wrapping struct
    /// - Returns: `URLRequest?` properly configured. (nil if there was a problem)
    func buildURLRequest(for request: APIRequest) -> URLRequest? {
        guard let url = request.url(datacenter: datacenter) else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpVerb().rawValue

        if case .post = request.httpVerb() {
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }

        if request.requiresAuth() {
            urlRequest.addBasicAuthHeader(username: "apitoken", password: baseToken)
        }

        return urlRequest
    }


    // ----------------------------------------------------------------
    // MARK: - URL Session

    /// Create a default session to use with appropriate timout
    ///
    /// - Returns: `URLSession` with proper configuration
    fileprivate func session() -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10
        sessionConfig.timeoutIntervalForResource = 20

        return URLSession(configuration: sessionConfig)
    }
    
}
