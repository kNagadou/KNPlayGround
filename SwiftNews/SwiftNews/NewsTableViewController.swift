//
//  NewsTableViewController.swift
//  SwiftNews
//
//  Created by 長堂嘉寿将 on 2015/10/26.
//  Copyright © 2015年 DreamArts. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    let NEWS_URL = "http://dev.classmethod.jp/category/iphone/feed/"
    let GOOGLE_FEED_API = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://dev.classmethod.jp/category/iphone/feed/&num=10"
    var entries = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onRefreshButton(sender: AnyObject) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: GOOGLE_FEED_API)!, completionHandler: { data, response, error in
            // http://qiita.com/koher/items/0c60b13ff0fe93220210
            let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            if let responseData = dict["responseData"] as? NSDictionary {
                if let feed = responseData["feed"] as? NSDictionary {
                    if let entries = feed["entries"] as? NSArray {
                        self.entries = entries
                        print(entries)
                    }
                }
            }
        })
        task.resume()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("news")! as UITableViewCell
        cell.textLabel!.text = "Swift News"
        return cell
    }
}

