//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String , currency: String)
}

struct CoinManager {
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(currency: String) {
        
        let url = "\(baseURL)\(currency)"
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                }
                if let safeData = data{
                    if let currencyData = self.parseJSON(for: safeData){
                    let bitcoinString = String(format: "%.2f", currencyData)
                        self.delegate?.didUpdatePrice(price: bitcoinString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(for data: Data)->Double?{
        let decoder = JSONDecoder()
        do{
           let decodedData =  try decoder.decode(CoinData.self, from: data)
            let price = decodedData.last
            return price
        }catch{
            print(error)
            return nil
        }
        
    }
    
    
    
}
