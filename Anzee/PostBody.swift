//
//  PostBody.swift
//  Mailchimp SDK
//
//  Created by Michael Patzer on 5/7/19.
//  Copyright © 2019 Michael Patzer. All rights reserved.
//

import Foundation

// The PostBody may be an object that conforms to the Codable protocol (case object),
// or an object that conforms to the PostBodyParamable protocol (case params).
enum PostBody<T: Codable, U: PostBodyParamable> {
    case object(T)
    case params(U)
}

protocol PostBodyParamable {
    var params: [String: String] { get }
}

// A default empty implementation of the PostBodyParamable protocol,
// to be used when a function returns a PostBody of the other type
struct ParametersDefault: PostBodyParamable {
    var params: [String : String] = [:]
}

// A default empty implementation of the Codable protocol,
// to be used when a function returns a PostBody of the other type
struct CodableDefault: Codable {}
