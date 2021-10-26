//
//  StockManager.swift
//  Quantsapp-Testing
//
//  Created by Anis Agwan on 26/10/21.
//

import Foundation

struct StockModel: Codable {
    let l: String
    let lu: String
    let s: String
    let sc: String
}


protocol StockmanagerDelegate {
    func didUpdateStocks(_ stockManager: StockManager, stock: StockModel)
    func didFailWithError(error: Error)
}

struct StockManager {
    let baseURL: String =  "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/synopsis.json"
    
    var delegate: StockmanagerDelegate?
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("Error fetching")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let stock = self.parseJSON(safeData) {
                        
                        self.delegate?.didUpdateStocks(self, stock: stock)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON(_ data: Data) -> StockModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(StockModel.self, from: data)
            let l = decodedData.l
            let lu = decodedData.lu
            let s = decodedData.s
            let sc = decodedData.sc
            
            let stock = StockModel(l: l, lu: lu, s: s, sc: sc)
            return stock
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
