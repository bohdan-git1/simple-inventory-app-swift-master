//
//  SearchResultsViewController.swift
//  Collectkins
//
//  Created by Consigliere on 6/15/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsViewController: UITableViewController {
    
    var searchResults: [InventoryItemMO] = []
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
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
        return searchResults.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InventoryItem", forIndexPath: indexPath)

        // Configure the cell...
        let labelName = cell.contentView.viewWithTag(1000) as! UILabel
        labelName.text  = searchResults[indexPath.row].name
        
        let labelSeries = cell.contentView.viewWithTag(1001) as! UILabel
        labelSeries.text  = searchResults[indexPath.row].series.name
        
        let labelTeam = cell.contentView.viewWithTag(1002) as! UILabel
        labelTeam.text  = searchResults[indexPath.row].team.name
        
        let labelItemNumber = cell.contentView.viewWithTag(1003) as! UILabel
        labelItemNumber.text  = searchResults[indexPath.row].no
        
        let labelRarity = cell.contentView.viewWithTag(1004) as! UILabel
        labelRarity.text  = searchResults[indexPath.row].rarity.name
        
        let labelStatus = cell.contentView.viewWithTag(1005) as! UILabel
        labelStatus.text  = searchResults[indexPath.row].status.name
        
        let itemImageView = cell.contentView.viewWithTag(1006) as! UIImageView
        itemImageView.image = UIImage(data: searchResults[indexPath.row].image)

        return cell
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let itemDetailsVC = storyboard?.instantiateViewControllerWithIdentifier("ItemDetailsViewController") as! ItemDetailsViewController
        itemDetailsVC.itemDetails = searchResults[indexPath.row]
        navigationController?.pushViewController(itemDetailsVC, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            appDelegate.cdController.backgroundContext?.deleteObject(searchResults[indexPath.row] as NSManagedObject)
            searchResults.removeAtIndex(indexPath.row)
            appDelegate.cdController.saveContext()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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
