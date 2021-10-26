//
//  ViewController.swift
//  Quantsapp-Testing
//
//  Created by Anis Agwan on 26/10/21.
//

import UIKit

class StockViewController: UIViewController {

    var stockManager = StockManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stockManager.delegate = self
        
        stockManager.performRequest(with: "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/synopsis.json")
    }
    
}

extension StockViewController: StockmanagerDelegate {
    func didUpdateStocks(_ stockManager: StockManager, stock: StockModel) {
        print("STOCKS L: \(stock.l)")
        print("STOCKS: \(stock.lu)")
        print("STOCKS: \(stock.s)")
        print("STOCKS: \(stock.sc)")
    }
    
    func didFailWithError(error: Error) {
        print("ERROR: \(error)")
    }
    
    
}
