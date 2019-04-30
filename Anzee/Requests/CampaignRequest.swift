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
            let response = try decoder.decode(Campaign.self, from: json)
            callback?(response, nil)
        } catch {
            if let responseError = try? decoder.decode(APIErrorResponse.self, from: json) {
                callback?(nil, .apiError(response: responseError))
            } else {
                callback?(nil, .jsonParsingError(err: "Unknown"))
            }
        }
    }

}
