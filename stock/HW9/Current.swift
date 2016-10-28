//
//  Current.swift
//  FirstDemo
//
//  Created by stoic on 4/12/16.
//  Copyright © 2016 Simeng Yu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CCAutocomplete
import CoreData
import Social
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, FBSDKSharingDelegate{
    
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    
    var detailTableView: UITableView!
    
    var newsTableView: UITableView!
    
    var customSC: UISegmentedControl!
    
    var data: JSON!
    
    var identifier = "cell"
    var identifier2 = "cell2"
    
    var imageView: UIImageView!
    var imageUrlString: String!
    
    let currentScrollView = UIScrollView()

    
    var webView = UIWebView()
    var likeImage = UIImage()
    var likeButton = UIButton()
    
    var results: NSArray!
    
    //core data
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    @IBAction func drawDetailTable() {
        
        
        currentScrollView.frame = CGRectMake(0, self.customSC.frame.origin.y + self.customSC.frame.height, self.screenWidth, self.screenHeight - self.customSC.frame.origin.y)
        
        currentScrollView.pagingEnabled = true
        currentScrollView.showsHorizontalScrollIndicator = false
        currentScrollView.showsVerticalScrollIndicator = false
        currentScrollView.scrollsToTop = false
        self.view.addSubview(currentScrollView)
        
        //add label
        var label: UILabel = UILabel()
        label.frame = CGRectMake(22, 15, 120, 50)
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = "Stock Details"
        label.font = UIFont.boldSystemFontOfSize(18)
        currentScrollView.addSubview(label)
        
        //add facebook button
        var fbImage = UIImage(named: "facebook.png") as UIImage?
        var fbButton   = UIButton(type: UIButtonType.Custom) as UIButton
        fbButton.frame = CGRectMake(230, 15, 50, 50)
        fbButton.setImage(fbImage, forState: .Normal)
        fbButton.addTarget(self, action: "fbShare:", forControlEvents:.TouchUpInside)
        currentScrollView.addSubview(fbButton)
        
        //add like button
        likeImage = (UIImage(named: "star.png") as UIImage?)!
        likeButton   = UIButton(type: UIButtonType.Custom) as UIButton
        likeButton.frame = CGRectMake(300, 15, 50, 50)
        likeButton.setImage(likeImage, forState: .Normal)
        likeButton.addTarget(self, action: "likeStock:", forControlEvents:.TouchUpInside)
        currentScrollView.addSubview(likeButton)

        
        //draw table
        var tableFrame = CGRectMake(20, 70 , self.screenWidth - 40, 600)
        self.detailTableView = UITableView(frame: tableFrame, style: .Plain)
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        
        currentScrollView.addSubview(self.detailTableView)
        
        self.detailTableView.registerClass(MyTableViewCell.classForCoder(), forCellReuseIdentifier: self.identifier)
        
        //plot table chart
      
        self.imageUrlString = "http://chart.finance.yahoo.com/t?s="+inputSymbol+"&lang=en-US&width=400&height=300"
        
        let imgURL: NSURL = NSURL(string: self.imageUrlString)!
        let data = NSData(contentsOfURL: imgURL)
        let image = UIImage(data: data!)

        self.imageView = UIImageView(image: image!)
        
        imageView.frame = CGRectMake(20,self.detailTableView.frame.origin.y - 10 + self.detailTableView.frame.height ,self.screenWidth-40, 400/(self.screenWidth-40)*300)
        
        currentScrollView.addSubview(imageView)
        
        //plot stock chart
        webView = UIWebView(frame: CGRectMake(0,180,self.screenWidth ,800))
 
        self.webView.delegate = self;
        self.view.addSubview(webView)
        self.webView.delegate = self
        
        self.webView.loadHTMLString("<html><head><meta charset='UTF-8'><script src='https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js'></script><script src='https://code.highcharts.com/stock/highstock.js'></script><script src='https://code.highcharts.com/stock/modules/exporting.js'></script></head><body><div id='chartContent'></div><script>$(document).ready(function(){PlotChart('"+inputSymbol+"');});function PlotChart(symbol){$.ajax({data:{'symbolInput3':symbol},url:'https://helloworld1-1272.appspot.com/hw8.php',dataType: 'json',context:this,success: function(json){var chartSeries = [];chartSeries=getOHLC(jQuery.parseJSON(json));$('#chartContent').highcharts('StockChart', {chart:{renderTo:'#chartContent',},rangeSelector: {allButtonsEnabled: true,buttons: [{type: 'week',count: 1,text: '1w'},{type: 'month',count: 1,text: '1m'}, {type: 'month',count: 3,text: '3m'}, {type: 'month',count: 6,text: '6m'}, {type: 'ytd',text: 'YTD'}, {type: 'year',count: 1,text: '1y'}, {type: 'all',text: 'All'}],buttonTheme: {width: 30},selected: 0,inputEnabled: false,},tooltip:{valuePrefix:'$',valueDecimals:2},title: {text: symbol + ' Stock Value'},navigation: {buttonOptions: {enabled: false}},yAxis: [{title:{text: 'Stock Value'}}],series: [{type: 'area',name: symbol,data: chartSeries,fillColor : {linearGradient : {x1: 0,y1: 0,x2: 0,y2: 1},stops : [[0, Highcharts.getOptions().colors[0]],[1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]]}}]});},});}function _fixDate(dateIn) {var dat = new Date(dateIn);return Date.UTC(dat.getFullYear(), dat.getMonth(), dat.getDate());}function getOHLC(json) {var dates = json.Dates || [];var elements = json.Elements || [];var chartSeries = [];if (elements[0]){for (var i = 0, datLen = dates.length; i < datLen; i++) {var dat = this._fixDate( dates[i] );var pointData = [dat,elements[0].DataSeries['open'].values[i],elements[0].DataSeries['high'].values[i],elements[0].DataSeries['low'].values[i],elements[0].DataSeries['close'].values[i]];chartSeries.push( pointData );};}return chartSeries;}</script></body></html>", baseURL: nil)
        
        self.webView.userInteractionEnabled = true
        self.webView.scrollView.scrollEnabled = false
        
        //draw news table
        
        var tableFrame2 = CGRectMake(0,  self.customSC.frame.origin.y + self.customSC.frame.height, self.screenWidth, self.screenHeight - tableFrame.origin.y - 64)
        self.newsTableView = UITableView(frame: tableFrame2, style: .Plain)
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        
        self.view.addSubview(self.newsTableView)
        
        
        self.newsTableView.registerClass(NewsTableCell.classForCoder(), forCellReuseIdentifier: self.identifier2)
        
        currentScrollView.contentSize=CGSizeMake(self.screenWidth,
                                                 self.detailTableView.frame.height + imageView.frame.height + 150)
  
    }
    
  
    
    func fbShare(sender: UIButton!) {
        
        let content = FBSDKShareLinkContent.init()
        
       // let str = "http://finance.yahoo.com/echarts?s="+String(tableDetails["Symbol"])+"+Interactive#{\"range\":\"1d\",\"allowChartStacking\":true}"
        
        content.contentURL = NSURL(string: "http://finance.yahoo.com/q?s="+String(tableDetails["Symbol"]))
        //content.contentURL = NSURL(string: "http://finance.yahoo.com")
        
        let lastPrice1:Float = tableDetails["LastPrice"].float!
        let s1 = NSString(format: "%.2f", lastPrice1)
        content.contentTitle = "Current Price of " + String(tableDetails["Symbol"]) + " is $" + String(s1)
        
        content.contentDescription = "Stock Information of " + String(tableDetails["Name"]) + "( " + String(tableDetails["Symbol"]) + " )"
        
        content.imageURL = NSURL(string: self.imageUrlString)
        
        let shareDialog = FBSDKShareDialog.init()
        shareDialog.fromViewController = self
        shareDialog.shareContent = content
        shareDialog.delegate = self
        
        shareDialog.show()
    }
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        let alert = UIAlertController(title: "Facebook Share", message: "Success!", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        let alert = UIAlertController(title: "Facebook Share", message: "Failed!", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func sharerDidCancel(sharer: FBSDKSharing!) {
        let alert = UIAlertController(title: "Facebook Share", message: "Canceled!", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func likeStock(sender: UIButton!){

        
        switch sender.tag {
        case 0:
            //save the data
            
            self.likeButton.setImage(UIImage(named: "starFilled"), forState: UIControlState.Normal)
            self.likeButton.tag = 1
            
            let newSavedData = NSEntityDescription.insertNewObjectForEntityForName("SavedData", inManagedObjectContext: self.managedObjectContext) as! SavedData
            
            newSavedData.setValue(String(tableDetails["Symbol"]), forKey: "symbol")
            newSavedData.setValue(String(tableDetails["Name"]), forKey: "stockName")
            
            let lastPrice:Float = tableDetails["LastPrice"].float!
            var s = NSString(format: "%.2f", lastPrice)
            newSavedData.setValue(String("$" + (s as String)), forKey: "price")
            
            let change:Float = tableDetails["Change"].float!
            
            if change>0 {
                newSavedData.setValue("positive", forKey: "changeSign")
            }else if change < 0 {
                newSavedData.setValue("negative", forKey: "changeSign")
            }else{
                newSavedData.setValue("zero", forKey: "changeSign")
            }
            
            
            s = String(format: "%.2f", change)
            if(change > 0){
                s = "+" + (s as String)
                
            }
            let changePercent:Float = tableDetails["ChangePercent"].float!
            var s2 = String(format: "%.2f", changePercent)
            if(changePercent > 0){
                s2 = "+" + s2
            }
            newSavedData.setValue((s as String) + "(" + s2 + "%)", forKey: "change")
            //        newSavedData.change = (s as String) + "(" + s2 + "%)"
            
            var cap:Int = tableDetails["MarketCap"].int!
            var num:Float!
            var str:String!
            if(cap > 1000000000){
                num = Float(cap) / 1000000000.0
                str = NSString(format: "%.2f", num) as String
                str = "Market Cap: " + str + " Billion"
            }else if(cap > 1000000){
                num = Float(cap) / 1000000.0
                str = NSString(format: "%.2f", num) as String
                str = "Market Cap: " + str + " Million"
            }else{
                
                str = "Market Cap: " + String(cap)
            }
            newSavedData.setValue(str, forKey: "cap")
            
            
            newSavedData.setValue("https://helloworld2-1283.appspot.com/hw8.php?symbolInput=" + String(tableDetails["Symbol"]), forKey: "stockUrl")
            
            
            
            do {
                try self.managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save \(error),\(error.userInfo)")
            }

            
            break
        case 1:
            //unsave the data
            self.likeButton.setImage(UIImage(named: "star"), forState: .Normal)
            self.likeButton.tag = 0
            
            
            var request = NSFetchRequest(entityName: "SavedData")
            request.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "symbol == %@",tableDetails["Symbol"].string!)
            request.predicate = predicate
            
            var fetchResult: NSArray!
            
            do {
                fetchResult = try self.managedObjectContext.executeFetchRequest(request)
                if fetchResult.count == 0 {
                    print("no item found")
                    
                }else{
                    print("found")
                    
                    for res in fetchResult {
                        self.managedObjectContext.deleteObject(res as! NSManagedObject)
                    }
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch let error as NSError{
                        print(error)
                    }
                    
                }
                
                
            } catch let error as NSError {
                print(error)
            }

            break
        default:
            break
        }

    }
    
    func changePage(sender: UISegmentedControl) {
        
        print("!")
        
        switch sender.selectedSegmentIndex {
        case 1:
        
            currentScrollView.hidden = true
            webView.hidden = false
            newsTableView.hidden = true
        case 2:
           
            currentScrollView.hidden = true
            webView.hidden = true
            newsTableView.hidden = false
        default:
          
            currentScrollView.hidden = false
            webView.hidden = true
            newsTableView.hidden = true
            
        }
    }
    
    
    
    override func viewDidLoad() {
        
        
        let items = ["Current", "Historical", "News"]
        self.customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        customSC.backgroundColor = UIColor.whiteColor()
        
        customSC.frame = CGRectMake(20, 90,
                                    self.screenWidth - 40, self.screenHeight * 0.08)
        
        
        customSC.addTarget(self, action: "changePage:", forControlEvents: .ValueChanged)
        
        self.view.addSubview(customSC)

        
        drawDetailTable()
        webView.hidden = true
        newsTableView.hidden = true
        self.detailTableView.scrollEnabled = false
        self.detailTableView.userInteractionEnabled = false
        
        
        
        self.newsTableView.rowHeight = 230.0
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        //for core data
        
        
    }
    
    
    //init all stock detail labels
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.detailTableView {
            return 50
        }else{
            return 230
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case detailTableView:
            return 11
            
        case newsTableView:
            return newsDetails["d"]["results"].count
            
        default:
            return 11
        }
       
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch tableView {
            case detailTableView:
            
                let cell = tableView.dequeueReusableCellWithIdentifier(self.identifier, forIndexPath: indexPath) as! MyTableViewCell
                
                if (indexPath.row == 0){
                    cell.nameLabel.text = "Name"
                    let name:String = tableDetails["Name"].string!
                    cell.contentLabel.text = name
                }else if (indexPath.row == 1){
                    cell.nameLabel.text = "Symbol"
                    let symbol:String = tableDetails["Symbol"].string!
                    cell.contentLabel.text = symbol
                }else if(indexPath.row == 2){
                    cell.nameLabel.text = "Last Price"
                    let lastPrice:Float = tableDetails["LastPrice"].float!
                    let s = NSString(format: "%.2f", lastPrice)
                    cell.contentLabel.text = "$ "+String(s)
                }else if(indexPath.row == 3){
                    
                    cell.nameLabel.text = "Change"
                    let change:Float = tableDetails["Change"].float!
                    
                    var s = String(format: "%.2f", change)
                    if(change > 0){
                        s = "+" + s
                    }
                    let changePercent:Float = tableDetails["ChangePercent"].float!
                    var s2 = String(format: "%.2f", changePercent)
                    if(changePercent > 0){
                        s2 = "+" + s2
                    }
                    cell.contentLabel.text = s + "(" + s2 + "%)"
                    
                    if change > 0 {
                        cell.arrowImage.image = UIImage(named: "up")
                        cell.arrowImage.hidden = false
                    }else if change < 0 {
                        cell.arrowImage.image = UIImage(named: "down")
                        cell.arrowImage.hidden = false
                    }
                    
                    
                    
                }else if(indexPath.row == 4){
                    cell.nameLabel.text = "Time and Date"
                    var time:String = String(tableDetails["Timestamp"])
                    
                  
//                    let timestamp = NSDate().timeIntervalSince1970
//                    print("stamp",timestamp)
                    
                
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "EEE MMM d HH:mm:ss ZZZZ yyyy"
                    dateFormatter.timeZone = NSTimeZone(name: "UTC/Pacific")
                    
                    var date = dateFormatter.dateFromString(time)
                    dateFormatter.dateFormat = "MMM d yyyy HH:mm"
                    time = dateFormatter.stringFromDate(date!)
      
//                    var timeStamp = dateFormatter.dateFromString(time)
//                    
//                    dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"
//                    dateFormatter.timeZone = NSTimeZone(name: "UTC")
//                    time = dateFormatter.stringFromDate(timeStamp!)
                    
                    
                    
                    cell.contentLabel.text = (time as String)
                    
                }else if(indexPath.row == 5){
                    cell.nameLabel.text = "Market Cap"
                    var cap:Int = tableDetails["MarketCap"].int!
                    var num:Float!
                    var str:String!
                    if(cap > 1000000000){
                        num = Float(cap) / 1000000000.0
                        str = NSString(format: "%.2f", num) as String
                        str = str + " Billion"
                    }else if(cap > 1000000){
                        num = Float(cap) / 1000000.0
                        str = NSString(format: "%.2f", num) as String
                        str = str + " Million"
                    }else{
                        
                        str = String(cap)
                    }
                    cell.contentLabel.text = str
                    
                }else if(indexPath.row == 6){
                    cell.nameLabel.text = "Volume"
                    let vol:Int = tableDetails["Volume"].int!
                    cell.contentLabel.text = String(vol)
                    
                }else if(indexPath.row == 7){
                    cell.nameLabel.text = "Change YTD"
                    let changeYTD:Float = tableDetails["ChangeYTD"].float!
                    var s = String(format:"%.2f",changeYTD)
                    if(changeYTD > 0){
                        s = "+" + s
                    }
                    let changeYTDPercent:Float = tableDetails["ChangePercentYTD"].float!
                    var  s2 = String(format:"%.2f",changeYTDPercent)
                    if(changeYTDPercent > 0){
                        s2 = "+" + s2
                    }
                    
                    cell.contentLabel.text = s + "(" + s2 + "%)"
                    
                    if changeYTD > 0 {
                        cell.arrowImage.image = UIImage(named: "up")
                        cell.arrowImage.hidden = false
                    }else if changeYTD < 0 {
                        cell.arrowImage.image = UIImage(named: "down")
                        cell.arrowImage.hidden = false
                    }
                    
                }else if(indexPath.row == 8){
                    cell.nameLabel.text = "High Price"
                    let high:Float = tableDetails["High"].float!
                    cell.contentLabel.text = "$ " + String(high)
                }else if(indexPath.row == 9){
                    cell.nameLabel.text = "Low Price"
                    let low:Float = tableDetails["Low"].float!
                    cell.contentLabel.text = "$ " + String(low)
                }else if(indexPath.row == 10){
                    cell.nameLabel.text = "Open Price"
                    let open:Float = tableDetails["Open"].float!
                    cell.contentLabel.text = "$ " + String(open)
                }
                
                
                return cell
            
        case newsTableView:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(self.identifier2, forIndexPath: indexPath) as! NewsTableCell
            
            for i in 0...newsDetails["d"]["results"].count-1 {
                if(indexPath.row == i){
                    cell.titleLabel.text = String(newsDetails["d"]["results"][i]["Title"])
                    cell.contentLabel.text = String(newsDetails["d"]["results"][i]["Description"])
                    cell.authorLabel.text = String(newsDetails["d"]["results"][i]["Source"])
                    var time = String(newsDetails["d"]["results"][i]["Date"])
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    dateFormatter.timeZone = NSTimeZone(name: "UTC/Pacific")
                    
                    var date = dateFormatter.dateFromString(time)
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    time = dateFormatter.stringFromDate(date!)
                    
                    cell.dateLabel.text = time
                }
            }
            
            return cell
            
        default:
            let cell = UITableViewCell()
            cell.textLabel!.text = String(format:"222")
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == newsTableView {

            var url = NSURL(string: String(newsDetails["d"]["results"][indexPath.row]["Url"]))

            UIApplication.sharedApplication().openURL(url!)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var request = NSFetchRequest(entityName: "SavedData")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "symbol == %@",tableDetails["Symbol"].string!)
        request.predicate = predicate
        
        
        do {
            self.results = try self.managedObjectContext.executeFetchRequest(request)
            if results.count == 0 {
                    print("item not found")
                self.likeButton.setImage(UIImage(named: "star"), forState: .Normal)
                self.likeButton.tag = 0
            }else{
                print("item found")
                self.likeButton.setImage(UIImage(named: "starFilled"), forState: .Normal)
                self.likeButton.tag = 1
            }
            
            
        } catch let error as NSError {
            print(error)
        }
        
        self.detailTableView.reloadData()
        
        self.imageUrlString = "http://chart.finance.yahoo.com/t?s="+inputSymbol+"&lang=en-US&width=400&height=300"
        
        let imgURL: NSURL = NSURL(string: self.imageUrlString)!
        let data = NSData(contentsOfURL: imgURL)
        let image = UIImage(data: data!)
        
        self.imageView.image = image
        
        self.newsTableView.reloadData() 
        
        self.webView.loadHTMLString("<html><head><meta charset='UTF-8'><script src='https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js'></script><script src='https://code.highcharts.com/stock/highstock.js'></script><script src='https://code.highcharts.com/stock/modules/exporting.js'></script></head><body><div id='chartContent'></div><script>$(document).ready(function(){PlotChart('"+inputSymbol+"');});function PlotChart(symbol){$.ajax({data:{'symbolInput3':symbol},url:'https://helloworld1-1272.appspot.com/hw8.php',dataType: 'json',context:this,success: function(json){var chartSeries = [];chartSeries=getOHLC(jQuery.parseJSON(json));$('#chartContent').highcharts('StockChart', {chart:{renderTo:'#chartContent',},rangeSelector: {allButtonsEnabled: true,buttons: [{type: 'week',count: 1,text: '1w'},{type: 'month',count: 1,text: '1m'}, {type: 'month',count: 3,text: '3m'}, {type: 'month',count: 6,text: '6m'}, {type: 'ytd',text: 'YTD'}, {type: 'year',count: 1,text: '1y'}, {type: 'all',text: 'All'}],buttonTheme: {width: 30},selected: 0,inputEnabled: false,},tooltip:{valuePrefix:'$',valueDecimals:2},title: {text: symbol + ' Stock Value'},navigation: {buttonOptions: {enabled: false}},yAxis: [{title:{text: 'Stock Value'}}],series: [{type: 'area',name: symbol,data: chartSeries,fillColor : {linearGradient : {x1: 0,y1: 0,x2: 0,y2: 1},stops : [[0, Highcharts.getOptions().colors[0]],[1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]]}}]});},});}function _fixDate(dateIn) {var dat = new Date(dateIn);return Date.UTC(dat.getFullYear(), dat.getMonth(), dat.getDate());}function getOHLC(json) {var dates = json.Dates || [];var elements = json.Elements || [];var chartSeries = [];if (elements[0]){for (var i = 0, datLen = dates.length; i < datLen; i++) {var dat = this._fixDate( dates[i] );var pointData = [dat,elements[0].DataSeries['open'].values[i],elements[0].DataSeries['high'].values[i],elements[0].DataSeries['low'].values[i],elements[0].DataSeries['close'].values[i]];chartSeries.push( pointData );};}return chartSeries;}</script></body></html>", baseURL: nil)

        
        
        self.navigationController?.navigationBar.hidden = false

    }

}






