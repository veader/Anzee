//
//  URLRequest.swift
//  Anzee
//
//  Created by Shawn Veader on 4/23/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

extension URLRequest {
    /// Add a basic authorization header to the request.
    ///
    /// The username and password are combined and base 64 encoded per standards.
    ///
    /// - Parameters:
    ///     - username: `String` representing the username
    ///     - password: `String?` representing the password
    public mutating func addBasicAuthHeader(username: String, password: String?) {
        let authString = "\(username):\(password ?? "")"
        if let authData = authString.data(using: String.Encoding.utf8) {
            let base64AuthString = authData.base64EncodedString()
            setValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
        }
    }
}
