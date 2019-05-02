//
//  AnzeeTests.swift
//  AnzeeTests
//
//  Created by Shawn Veader on 4/2/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest
@testable import Anzee

class AnzeeTests: XCTestCase {

    var api: AnzeeAPI?

    override func setUp() {
        api = AnzeeAPI(token: "PUT API TOKEN HERE")
    }

//    override func tearDown() {
//    }

    func testCampaignsRequest() {
        var campaigns: [Campaign]?

        let group = DispatchGroup()
        group.enter()

        var request = CampaignsRequest { result in
            defer { group.leave() }
            
            switch result {
            case .success(let downloadedCampaigns):
                campaigns = downloadedCampaigns
            case .failure:
                XCTFail()
            }
        }

        api?.process(request: request)
        group.wait()

        XCTAssertEqual(10, campaigns?.count)
    }

    func testCampaignRequest() {
        var campaign: Campaign?

        let group = DispatchGroup()
        group.enter()

        var request = CampaignRequest(campaignID: "CAMPAIGN ID") { result in
            defer { group.leave() }
            
            switch result {
            case .success(let downloadedCampaign):
                campaign = downloadedCampaign
            case .failure:
                XCTFail()
            }
        }

        api?.process(request: request)
        group.wait()

        XCTAssertNotNil(campaign)
        // print(result)
    }

}
