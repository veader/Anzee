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
        var result: [Campaign]?

        let group = DispatchGroup()
        group.enter()

        var request = CampaignsRequest { campaigns, error in
            defer { group.leave() }
            XCTAssertNil(error)
            result = campaigns
        }

        api?.process(request: request)
        group.wait()

        XCTAssertEqual(10, result?.count)
        // print(result?.first)
    }

    func testCampaignRequest() {
        var result: Campaign?

        let group = DispatchGroup()
        group.enter()

        var request = CampaignRequest(campaignID: "CAMPAIGN ID") { campaign, error in
            defer { group.leave() }
            XCTAssertNil(error)
            result = campaign
        }

        api?.process(request: request)
        group.wait()

        XCTAssertNotNil(result)
        // print(result)
    }

}
