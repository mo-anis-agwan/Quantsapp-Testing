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
    var collArr: [Stock]?
    
    @IBOutlet weak var stocksCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stockManager.delegate = self
        searchTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
         
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        stockManager.performRequest(with: "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/synopsis.json")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func allbtnpressed(_ sender: Any) {
        self.collArr = self.allStockPrice
        DispatchQueue.main.async {
            self.stocksCollectionView.reloadData()
        }
    }
    
    @IBAction func Lbtnpressed(_ sender: Any) {
        self.collArr = self.longStockPrice
        DispatchQueue.main.async {
            self.stocksCollectionView.reloadData()
        }
    }
    
    @IBAction func scBtnPressed(_ sender: Any) {
        self.collArr = self.scStockPrice
        DispatchQueue.main.async {
            self.stocksCollectionView.reloadData()
        }
    }
    
    @IBAction func sBtnPressed(_ sender: Any) {
        self.collArr = self.shortStockPrice
        DispatchQueue.main.async {
            self.stocksCollectionView.reloadData()
        }
    }
    
    @IBAction func luBtnPressed(_ sender: Any) {
        self.collArr = self.luStockPrice
        DispatchQueue.main.async {
            self.stocksCollectionView.reloadData()
        }
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    
    
    
}

extension StockViewController: StockmanagerDelegate {
    func didUpdateStocks(_ stockManager: StockManager, stock: StockModel) {
        
        self.longStockPrice = stringSplitArr(stock.l, bgColor: UIColor(named: "Lcolor") ?? UIColor.green)
        self.luStockPrice = stringSplitArr(stock.lu, bgColor: UIColor(named: "LUcolor") ?? UIColor.green)
        self.shortStockPrice = stringSplitArr(stock.s, bgColor: UIColor(named: "Scolor") ?? UIColor.green)
        self.scStockPrice = stringSplitArr(stock.sc, bgColor: UIColor(named: "SCcolor") ?? UIColor.green)
        
        self.allStockPrice = self.longStockPrice! + self.luStockPrice! + self.shortStockPrice! + self.scStockPrice!
        self.collArr = self.allStockPrice
        
        
        DispatchQueue.main.async {
            self.stocksCollectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print("ERROR: \(error)")
    }
    
    
    func stringSplitArr(_ str: String, bgColor: UIColor) -> [Stock] {
        let tempArr = str.split(separator: ";")
        var tempStockArr = [Stock]()
        
        tempArr.forEach { stc in
            //print("STC: \(stc)")
            let stcTempArr = stc.split(separator: ",")
            let stck = Stock(symbol: String(stcTempArr[0]), price: String(stcTempArr[1]), openInterest: String(stcTempArr[2]), priceChangePercent: String(stcTempArr[3]), openInterestChangePercent: String(stcTempArr[4]), colorCode: bgColor)
            //print("STOCK: \(stck)")
            tempStockArr.append(stck)
            }
        
        return tempStockArr
        
    }
    
}

extension StockViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Search"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let searchText = searchTextField.text {
            let tempArr = self.allStockPrice?.filter({ (stock) in
                stock.symbol.contains(searchText.uppercased())
            })

            textField.resignFirstResponder()
            self.collArr = tempArr
            DispatchQueue.main.async {
                self.stocksCollectionView.reloadData()
            }
        }
    }
    
}

extension StockViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let obj = self.collArr![indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stockCell", for: indexPath) as! StockCollectionViewCell
        
        cell.stockName.text = obj.symbol
        
        if let pricePercent = Double(obj.priceChangePercent) {
            let percent = pricePercent * 100
            let percentString = String(format: "%.3f", percent)
            
            cell.priceChangePercent.text = "\(percentString)%"
        } else {
            cell.priceChangePercent.text = "\(obj.priceChangePercent)%"
        }
        
        
        
        cell.backgroundColor = obj.colorCode
        
        return cell
    }
    
    
    
    
}
