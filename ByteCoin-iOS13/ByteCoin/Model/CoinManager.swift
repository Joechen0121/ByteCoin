//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegates {
    func didUpdateCoinData(currency: String, coinRate: Double)
    func didFailedwithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "5E652A80-1FB7-4C6C-B043-6B429DEED085"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegates?
    
    func getCoinPrice(for currency: String) {
        
        //let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        let urlString = baseURL + "/" + currency + "?apikey=" + apiKey
        
        print(urlString)
        // Create a URL
        if let url = URL(string: urlString) {
        
            // Create a Session
            let session = URLSession(configuration: .default)
            
            //Give a sesion a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailedwithError(error: error!)
                    return
                }

                if let safeData = data {
                    if let rate = self.parseJSON(safeData) {
                        print(rate)
                        self.delegate?.didUpdateCoinData(currency: currency, coinRate: rate)
                    }
                }
            }
            
            task.resume()
        }
    }
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let rate = decodedData.rate
            
            return rate
        } catch  {
            self.delegate?.didFailedwithError(error: error)
            return nil
        }
    }
}

