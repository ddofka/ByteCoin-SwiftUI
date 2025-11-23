//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CryptoPriceManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, price: CryptoPriceModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest"
    var apiKey: String {
            if let path = Bundle.main.path(forResource: "Secret", ofType: "plist"),
               let dict = NSDictionary(contentsOfFile: path),
               let key = dict["API_KEY"] as? String {
                return key
            }
            return ""
        }
    
    var delegate: CryptoPriceManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func fetchPrice(for currency: String) {
        let urlString = "\(baseURL)?symbol=BTC&convert=\(currency)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString) {
            
            var request = URLRequest(url: url)
            request.addValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let price = parseJSON(safeData){
                        delegate?.didUpdatePrice(self, price: price)                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ data: Data) -> CryptoPriceModel? {
            let decoder = JSONDecoder()
        
            do {
                let decoded = try decoder.decode(CoinMarketCapResponse.self, from: data)

                guard let firstEntry = decoded.data.first else { return nil }
                let symbol = firstEntry.key     // BTC
                let crypto = firstEntry.value   // the full crypto object
                
                guard let quote = crypto.quote.first?.value else { return nil }
                
                let model = CryptoPriceModel(
                    symbol: symbol,
                    name: crypto.name,
                    price: quote.price
                )
                
                return model
                
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
    
}
