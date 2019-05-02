//
//  Result.swift
//  Anzee
//
//  Created by Michael Patzer on 4/30/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

extension Result where Success == Data, Failure == APIError {
    func decoded<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let data = try get()
        return try decoder.decode(T.self, from: data)
    }
}
