//
//  SettingsViewController.swift
//  Collectkins
//
//  Created by Consigliere on 6/19/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class SettingsViewController: UITableViewController, TTTAttributedLabelDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StandardCell", forIndexPath: indexPath)

        // Configure the cell...
        let label = cell.contentView.viewWithTag(1001) as! UILabel
        let valueLabel = cell.contentView.viewWithTag(1000) as! TTTAttributedLabel
        valueLabel.delegate = self
        switch indexPath.row {
        case 0:
            label.text = "Version:"
            valueLabel.text = (NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String)!
            break
        case 1:
            label.text = "Website:"
            let url = "http://www.collectkins.com"
            valueLabel.text = url
            let range: NSRange = (valueLabel.text! as NSString).rangeOfString(url)
            valueLabel.addLinkToURL(NSURL(string: url), withRange: range)
            break
        case 2:
            label.text = "Email:"
            let emailAddress = "support@collectkins.com"
            valueLabel.text = emailAddress
            let range: NSRange = (valueLabel.text! as NSString).rangeOfString(emailAddress)
            valueLabel.addLinkToURL(NSURL(string: "mailto:\(emailAddress)"), withRange: range)
            break
        default:
            break
        }

        return cell
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
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
