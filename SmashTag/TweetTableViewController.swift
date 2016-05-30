//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Ali Abbas Jaffri on 29/05/2016.
//  Copyright © 2016 Ali Abbas Jaffri. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController
{
    var tweets = [Array<Twitter.Tweet>]()
    {
        didSet
        {
            tableView.reloadData()
        }
    }
    
    var searchText: String?
    {
        didSet
        {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
        
    }
    
    private var twitterRequest: Twitter.TwitterRequest?
    {
        if let query = searchText where !query.isEmpty
        {
            return Twitter.TwitterRequest(search: query + "-filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest : Twitter.TwitterRequest?

    private func searchForTweets()
    {
        if let request = twitterRequest
        {
            lastTwitterRequest = request
            request.fetchTweets
            {
                [weak weakSelf = self] newTweets in
                
                dispatch_async(dispatch_get_main_queue()) {
                    //if request == weakSelf?.lastTwitterRequest
                    //{
                        if !newTweets.isEmpty
                        {
                            weakSelf?.tweets.insert(newTweets, atIndex: 0)
                        }
                    //}
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText = "#stanford"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Tweet", forIndexPath: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        cell.textLabel?.text = tweet.text
        cell.detailTextLabel?.text = tweet.user.name
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
