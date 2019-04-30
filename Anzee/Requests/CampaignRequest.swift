//
//  CampaignRequest.swift
//  Anzee
//
//  Created by Shawn Veader on 4/25/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct CampaignRequest: APIRequest {
    let campaignID: String

    var params: [URLQueryItem]?

    var apiPath: String { return "/campaigns/\(campaignID)" }

    public typealias CampaignRequestCallback = ((_ campaign: Campaign?, _ error: APIError?) -> Void)

    /// Callback once API request is complete.
    public var callback: CampaignRequestCallback?


    init(campaignID: String, _ callback: @escaping CampaignRequestCallback) {
        self.campaignID = campaignID
        self.callback = callback
    }


    func requestComplete(_ result: Result<Data, APIError>) {
        do {
            let response = try result.decoded() as Campaign
            callback?(response, nil)
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
}
