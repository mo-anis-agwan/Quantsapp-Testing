//
//  ViewController.swift
//  Quantsapp-Testing
//
//  Created by Anis Agwan on 26/10/21.
//

import UIKit

class StockViewController: UIViewController {

    var stockManager = StockManager()
    var allStockPrice: [Stock]?
    var longStockPrice: [Stock]?
    var shortStockPrice: [Stock]?
    var luStockPrice: [Stock]?
    var scStockPrice: [Stock]?
    
//    @IBOutlet weak var stockCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stockManager.delegate = self
        searchTextField.delegate = self
        
        stockManager.performRequest(with: "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/synopsis.json")
    }
    
}

extension StockViewController: StockmanagerDelegate {
    func didUpdateStocks(_ stockManager: StockManager, stock: StockModel) {
        //print("STOCKS L: \(stock.l)")
        
        //print("SPLIT: \(stock.l.split(separator: ";"))")
        
        let allStr = stock.l + stock.lu + stock.s + stock.sc
        
        self.allStockPrice = stringSplitArr(allStr)
        
        self.longStockPrice = stringSplitArr(stock.l)
        self.luStockPrice = stringSplitArr(stock.lu)
        self.shortStockPrice = stringSplitArr(stock.s)
        self.scStockPrice = stringSplitArr(stock.sc)
    }
    
    func didFailWithError(error: Error) {
        print("ERROR: \(error)")
    }
    
    
    func stringSplitArr(_ str: String) -> [Stock] {
        let tempArr = str.split(separator: ";")
        var tempStockArr = [Stock]()
        
        tempArr.forEach { stc in
            //print("STC: \(stc)")
            let stcTempArr = stc.split(separator: ",")
            let stck = Stock(symbol: String(stcTempArr[0]), price: String(stcTempArr[1]), openInterest: String(stcTempArr[2]), priceChangePercent: String(stcTempArr[3]), openInterestChangePercent: String(stcTempArr[4]))
            //print("STOCK: \(stck)")
            tempStockArr.append(stck)
            }
        
        return tempStockArr
        
    }
    
}

extension StockViewController: UITextFieldDelegate {
    
}

//extension StockViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        //return cell
//    }
//
//}
