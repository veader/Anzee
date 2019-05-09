//
//  PostBody.swift
//  Mailchimp SDK
//
//  Created by Michael Patzer on 5/7/19.
//  Copyright © 2019 Michael Patzer. All rights reserved.
//

import Foundation

enum PostBody<T: Codable, U: PostBodyParamable> {
    case object(T)
    case params(U)
}

protocol PostBodyParamable {
    var params: [String: String] { get }
}

struct ParametersDefault: PostBodyParamable {
    var params: [String : String] = [:]
}

struct CodableDefault: Codable {}
