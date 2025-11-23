//
//  CoinMarketCapResponse.swift
//  ByteCoin
//
//  Created by Dovydas Dorofejevas on 23/11/2025.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import Foundation

struct CoinMarketCapResponse: Codable {
    let status: Status
    let data: [String: Crypto]
}

struct Status: Codable {
    let timestamp: String
    let error_code: Int
    let error_message: String?
}

struct Crypto: Codable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String?
    let quote: [String: Quote]
}

struct Quote: Codable {
    let price: Double
}
