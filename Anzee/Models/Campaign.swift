//
//  Campaign.swift
//  Anzee
//
//  Created by Shawn Veader on 4/23/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct Campaign: Codable {
    let campaignID: String
    let settings: CampaignSettings
    let status: String  // TODO: back this with a Codable enum
    let type: String    // TODO: back this with a Codable enum

    enum CodingKeys: String, CodingKey {
        case campaignID = "id"
        case type
        case settings
        case status
    }

    struct CampaignSettings: Codable {
        let subjectLine: String?
        let title: String?
        let fromName: String?
        let replyTo: String?
    }
}
