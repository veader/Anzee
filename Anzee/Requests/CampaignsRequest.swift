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

    var apiPath: String { return "campaigns" }

    public typealias CampaignsRequestCallback = ((_ campaigns: [Campaign]?, _ error: APIError?) -> Void)

    /// Callback once API request is complete.
    public var callback: CampaignsRequestCallback?


    init(_ callback: @escaping CampaignsRequestCallback) {
        self.callback = callback
    }

    func requestComplete(_ result: Result<Data, APIError>) {
        do {
            let response = try result.decoded() as CampaignsResponse
            callback?(response.campaigns, nil)
        } catch let apiError as APIError {
            callback?(nil, apiError)
        } catch {
            if let responseError = try? result.decoded() as APIErrorResponse {
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
