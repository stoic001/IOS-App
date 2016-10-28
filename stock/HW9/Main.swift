//
//  ViewController.swift
//  FirstDemo
//
//  Created by stoic on 4/8/16.
//  Copyright © 2016 Simeng Yu. All rights reserved.
//

import UIKit
import SwiftyJSON
import CCAutocomplete
import Foundation
import CoreData
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit


class ViewController: UIViewController, UITextFieldDelegate,  UITableViewDataSource{
    
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    
   // var inputSymbol = ""
    var autos = [String]()
    var newText:String = ""
    var autoSymbol = [String]()
    
    //for core data
    var savedData = [SavedData]()
    
    var autoRefreshSwitch: UISwitch!
    var refreshButton: UIButton!
    var refreshTimer: NSTimer!
    
    @IBOutlet weak var likeTableView: UITableView!
   
    
    let scrollView = UIScrollView()
    
    var detailView = ViewController2()
    
    var identifier = "cell"
    
    var refreshingIndicator: UIActivityIndicatorView!
 
    @IBOutlet weak var autocompleteContainerView: UIView!
  
   

    @IBOutlet weak var textView: UITextField!

    
    var autoCompleteViewController: AutoCompleteViewController!

   
    var isFirstLoad: Bool = true
    
    

    func drawLikeTable(){
        
    
        self.likeTableView.rowHeight = 80.0
      
        likeTableView.registerClass(LikeTableCell.classForCoder(), forCellReuseIdentifier: self.identifier)

    }
    
    
    
    @IBAction func getQuoteButton(sender: AnyObject) {
        
        var isValidSymbol:Bool = false
      
        self.textView.resignFirstResponder()
        
        
        for index in (textView.text?.characters.indices)! {
            if(textView.text![index] == "-") {
                
                inputSymbol = (textView.text?.substringToIndex(index))!
                break
            }else{
                inputSymbol = textView.text!
            }
        }
        
        
        if(autoSymbol.count > 0){
            for i in 0...autoSymbol.count-1 {
                
                if(autoSymbol[i]==inputSymbol){
                    isValidSymbol = true
                    break
                }
            }
        }
       
        let json : JSON = getStockInfo(inputSymbol)
        
        
        
        if(json != nil && String(json["Status"]) == "SUCCESS"){
            tableDetails = json
        }
        
        
        
        let json3 : JSON = getNewsInfo(inputSymbol)
        if(json3 != nil){
            newsDetails = json3
        }
        
        
        if (textView.text!.isEmpty) {
            let alertController = UIAlertController(title: "Please Enter a Stock Name or Symbol.", message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else if(isValidSymbol == false){
            let alertController = UIAlertController(title: "Invalid Symbol", message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }else if(String(json["Status"]) == "Failure|APP_SPECIFIC_ERROR"){
            let alertController = UIAlertController(title: "The stock you look up is not available now.", message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }else{
            
            self.detailView.navigationItem.title = inputSymbol
            self.navigationController?.pushViewController(self.detailView, animated: true)
        }

    }
    
    //table view delegates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(self.savedData.count)
        return self.savedData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.identifier, forIndexPath: indexPath) as! LikeTableCell
        
        let cellData: SavedData = self.savedData[indexPath.row]
        

        cell.symbolLabel.text = cellData.valueForKey("symbol") as? String
        cell.nameLabel.text = cellData.valueForKey("stockName") as? String
        cell.priceLabel.text = cellData.valueForKey("price") as? String
        cell.changeLabel.text = cellData.valueForKey("change") as? String
        cell.capLabel.text = cellData.valueForKey("cap") as? String
        
        switch cellData.valueForKey("changeSign") as! String {
        case "positive":
            cell.changeLabel.backgroundColor = UIColor.greenColor()
            cell.changeLabel.textColor = UIColor.whiteColor()
            break
        case "negative":
            cell.changeLabel.backgroundColor = UIColor.redColor()
            cell.changeLabel.textColor = UIColor.whiteColor()
            break
        case "zero":
            cell.changeLabel.backgroundColor = UIColor.whiteColor()
            cell.changeLabel.textColor = UIColor.blackColor()
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDel.managedObjectContext
            context.deleteObject(savedData[indexPath.row] as NSManagedObject)
            savedData.removeAtIndex(indexPath.row)
            
            do {
                try context.save()
            } catch let error as NSError{
                print(error)
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        inputSymbol = String(self.savedData[indexPath.row].symbol!)
        
        print(inputSymbol)
        
        let json : JSON = getStockInfo(inputSymbol)
        
        
        if json != nil {
            print("hehe")
 
        }
        
        if(json != nil && String(json["Status"]) == "SUCCESS"){
            tableDetails = json
        }
        

        
        
        let json3 : JSON = getNewsInfo(inputSymbol)
        if(json3 != nil){
            newsDetails = json3
        }

        
        self.detailView.navigationItem.title = inputSymbol
        self.navigationController?.pushViewController(self.detailView, animated: true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
 
    func getStockInfo(symbol:String)->JSON{
        let prefix : NSString = NSString(string:"https://helloworld2-1283.appspot.com/hw8.php?symbolInput=")
        let nsSymbol : NSString = NSString(string:symbol)
        let nsstrURL : NSString = (prefix as String) + (nsSymbol as String)
        let nsURL : NSURL = NSURL(string:nsstrURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        let data:NSData = NSData(contentsOfURL: nsURL)!
       
        let json = JSON(data: data)

        return json
        
    }
    
    func getNewsInfo(symbol:String)->JSON{
        let prefix : NSString = NSString(string:"https://helloworld2-1283.appspot.com/hw8.php?symbolInput2=")
        let nsSymbol : NSString = NSString(string:symbol)
        let nsstrURL : NSString = (prefix as String) + (nsSymbol as String)
        let nsURL : NSURL = NSURL(string:nsstrURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        let data:NSData = NSData(contentsOfURL: nsURL)!
        
        let json = JSON(data: data)

        return json

    }
    
    func getChartInfo(symbol:String)->JSON{
        let prefix : NSString = NSString(string:"https://helloworld1-1272.appspot.com/hw8.php?symbolInput3=")
        let nsSymbol : NSString = NSString(string:symbol)
        let nsstrURL : NSString = (prefix as String) + (nsSymbol as String)
        let nsURL : NSURL = NSURL(string:nsstrURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        let data:NSData = NSData(contentsOfURL: nsURL)!
        
        let json = JSON(data: data)

        return json
        
    }

    func getAutoInfo(symbol:String){
        autoSymbol = [String]()
        var sSymbol = ""
        var sName = ""
        var sExchange = ""
        
        
        let prefix : NSString = NSString(string:"https://helloworld2-1283.appspot.com/hw8.php?symbolInput4=")
        let nsSymbol : NSString = NSString(string:symbol)
        let nsstrURL : NSString = (prefix as String) + (nsSymbol as String)
        let nsURL : NSURL = NSURL(string:nsstrURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        let data:NSData = NSData(contentsOfURL: nsURL)!
        
        let json = JSON(data: data)

        if(json.count > 0){
            
           
            for i in 0...json.count-1 {
                sSymbol = String(json[i]["Symbol"])
               
                autoSymbol.append(sSymbol)
                sName = String(json[i]["Name"])
                sExchange = String(json[i]["Exchange"])
                var entry:String = sSymbol + "-" + sName + "-" + sExchange
                autos.append(entry)
            }
            
            for i in 0...autos.count-2 {
                for j in i+1 ... autos.count-1 {
                    if(autos[j]==autos[i]){
                        autos[j]=""
                    }
                }
            }
        }
    }
    
    

    func textField(textView: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        
        newText = textView.text!.stringByReplacingCharactersInRange(
            range.toRange(textView.text!), withString: string)
      
       
        getAutoInfo(newText)


        return true
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        drawLikeTable()
        textView.delegate = self
        
        self.autoRefreshSwitch = UISwitch()
        self.autoRefreshSwitch.frame = CGRectMake(260, 210, 50, 30)
        self.autoRefreshSwitch.backgroundColor = UIColor.whiteColor()
        self.autoRefreshSwitch.layer.cornerRadius = 16
        self.view.addSubview(self.autoRefreshSwitch)
        self.autoRefreshSwitch.on = false
        self.autoRefreshSwitch.addTarget(self, action: "switchOnClick:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.refreshButton = UIButton()
        self.refreshButton.setBackgroundImage(UIImage(named: "refresh"), forState: UIControlState.Normal)
        self.refreshButton.frame = CGRectMake(self.autoRefreshSwitch.frame.origin.x+self.autoRefreshSwitch.frame.width+10, self.autoRefreshSwitch.frame.origin.y, 30, 30)
        self.refreshButton.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.refreshButton)
        
        //for indicator view
        self.refreshingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.refreshingIndicator.tintColor = UIColor.greenColor()
        self.refreshingIndicator.color = UIColor.greenColor()
//        self.refreshingIndicator.backgroundColor = UIColor.greenColor()
        self.refreshingIndicator.frame = CGRectMake(self.screenWidth/2 - 50, self.screenHeight/2 - 50, 100, 100)
        self.view.addSubview(self.refreshingIndicator)
        
    }
    
    func switchOnClick(sender: AnyObject){
        if self.autoRefreshSwitch.on {
            //print("switch is on")
            self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "refreshData:", userInfo: nil, repeats: true)
            
        }else {
           // print("switch is off")
            self.refreshTimer.invalidate()
        }
    }
    
    func indicatorBegin(){
        self.refreshingIndicator.startAnimating()
        var refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "stopIndicator:", userInfo: nil, repeats: false)
    }
    
    func stopIndicator(sender: AnyObject){
        self.refreshingIndicator.stopAnimating()
    }
    
    func refreshData(sender: AnyObject){
        
        indicatorBegin()
        
        for data in self.savedData {
            
            var newData = getStockInfo(data.symbol!)
            
            let lastPrice:Float = newData["LastPrice"].float!
            var s = NSString(format: "%.2f", lastPrice)
            data.price = "$" + (s as String)
            
            let change:Float = newData["Change"].float!
            
            if change > 0 {
                data.changeSign = "positive"
            }else if change < 0 {
                data.changeSign = "negative"
            }else{
                data.changeSign = "zero"
            }
            
            s = String(format: "%.2f", change)
            if(change > 0){
                s = "+" + (s as String)
                
            }
            let changePercent:Float = newData["ChangePercent"].float!
            var s2 = String(format: "%.2f", changePercent)
            if(changePercent > 0){
                s2 = "+" + s2
            }
            data.change = (s as String) + "(" + s2 + "%)"
            
//            var cap:Int = newData["MarketCap"].int!
//            var num:Float!
//            var str:String!
//            if(cap > 1000000000){
//                num = Float(cap) / 1000000000.0
//                str = NSString(format: "%.2f", num) as String
//                str = "Market Cap: " + str + "Billion"
//            }else if(cap > 1000000){
//                num = Float(cap) / 1000000.0
//                str = NSString(format: "%.2f", num) as String
//                str = "Market Cap: " + str + "Million"
//            }else{
//                
//                str = "Market Cap: " + String(cap)
//            }
//            data.cap = str
            
            //modify core data record
            var appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
            
            var context = appDel.managedObjectContext
            var fetchRequest = NSFetchRequest(entityName: "SavedData")
            fetchRequest.predicate = NSPredicate(format: "symbol = %@", data.symbol!)
            
            do {
                let fetchResults = try context.executeFetchRequest(fetchRequest) as! [SavedData]
                if fetchResults.count != 0 {
                    fetchResults[0].setValue(data.price!, forKey: "price")
                    fetchResults[0].setValue(data.change!, forKey: "change")
//                    fetchResults[0].setValue(data.cap!, forKey: "cap")
                    
                    do {
                        try context.save()
                    } catch let err as NSError{
                        print(err)
                    }
                }
            } catch let error as NSError{
                print(error)
            }
        }
        
        
        
        self.likeTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        if self.isFirstLoad {
            self.isFirstLoad = false
            Autocomplete.setupAutocompleteForViewcontroller(self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //print("view will appear")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "SavedData")
        
        
        do {
            self.savedData = try managedContext.executeFetchRequest(fetchRequest) as! [SavedData]
        } catch let error as NSError {
            print("Could not save \(error),\(error.userInfo)")
        } catch {
            print("hehe")
        }
        
        self.refreshData(self.refreshButton)
        self.likeTableView.reloadData()
        self.navigationController?.navigationBar.hidden = true
    }
    
}


extension ViewController: AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField {
        return self.textView
    }
    
    func autoCompleteThreshold(textField: UITextField) -> Int {
        return 2
    }
    
    func autoCompleteItemsForSearchTerm(term: String) -> [AutocompletableOption] {
        let filteredCountries = self.autos.filter { (country) -> Bool in
            return country.lowercaseString.containsString(term.lowercaseString)
        }
        
        let countriesAndFlags: [AutocompletableOption] = filteredCountries.map { (var country) -> AutocompleteCellData in
            country.replaceRange(country.startIndex...country.startIndex, with: String(country.characters[country.startIndex]).capitalizedString)
            return AutocompleteCellData(text: country, image: UIImage(named: country))
            }.map( { $0 as AutocompletableOption })
        
        return countriesAndFlags
    }
    
    func autoCompleteHeight() -> CGFloat {
        return CGRectGetHeight(self.view.frame) / 3.0
    }
    
    
    func didSelectItem(item: AutocompletableOption) {
        //self.lblSelectedContryName.text = item.text
        self.textView.text = item.text
    }
}

extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = string.startIndex.advancedBy(self.location)
        let endIndex = startIndex.advancedBy(self.length)
        return startIndex..<endIndex
    }
}



