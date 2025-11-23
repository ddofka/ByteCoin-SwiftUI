//
//  CryptoPriceModel.swift
//  ByteCoin
//
//  Created by Dovydas Dorofejevas on 23/11/2025.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import Foundation

struct CryptoPriceModel {
    let symbol: String
    let name: String
    let price: Double
    
    var priceString: String {
        String(format: "%.2f", price)
    }
}
