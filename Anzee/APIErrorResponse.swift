//
//  APIErrorResponse.swift
//  Anzee
//
//  Created by Shawn Veader on 4/23/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

/// Basic struct to parse any possible API error responses
public struct APIErrorResponse: Codable {
    public let status: Int
    public let type: String
    public let detail: String
}
