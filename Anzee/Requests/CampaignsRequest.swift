//
//  CampaignsRequest.swift
//  Anzee
//
//  Created by Shawn Veader on 4/2/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct CampaignsRequest: APIRequest {
    var params: [URLQueryItem]?

    var apiPath: String { return "/campaigns" }

    public typealias CampaignsRequestCallback = ((_ campaigns: [Campaign]?, _ error: APIError?) -> Void)

    /// Callback once API request is complete.
    public var callback: CampaignsRequestCallback?


    init(_ callback: @escaping CampaignsRequestCallback) {
        self.callback = callback
    }


    func requestComplete(data: Data?, error apiError: APIError?) {
        guard apiError == nil else {
            callback?(nil, apiError)
            return
        }

        guard let json = data else {
            callback?(nil, .jsonMissingData)
            return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let response = try decoder.decode(CampaignsResponse.self, from: json)
            callback?(response.campaigns, nil)
        } catch {
            if let responseError = try? decoder.decode(APIErrorResponse.self, from: json) {
                callback?(nil, .apiError(response: responseError))
            } else {
                callback?(nil, .jsonParsingError(err: "Unknown"))
            }
        }
    }


    // Internal struct to parse response
    private struct CampaignsResponse: Codable {
        let campaigns: [Campaign]
        let totalItems: Int
    }
}
