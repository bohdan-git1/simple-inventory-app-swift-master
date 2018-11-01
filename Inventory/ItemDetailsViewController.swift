//
//  ItemDetailsViewController.swift
//  Collectkins
//
//  Created by Consigliere on 6/16/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import UIKit

class ItemDetailsViewController: AppBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var itemDetails: InventoryItemMO?
    var itemDetailsKeyTitles: [String] = ["Name", "Series", "Team", "Item #", "Rarity", "Status", "Quantity"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        if self.isModal() {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(ItemDetailsViewController.didTapClose))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(ItemDetailsViewController.didTapEdit))
        }
        
        let screenSize = UIScreen.mainScreen().bounds
        if let backgroundImage = UIImage(named: "Background-\(Int(screenSize.width))x\(Int(screenSize.height))") {
            self.tableView.backgroundView = UIImageView(image: backgroundImage)
        }
    }
    
    func isModal() -> Bool {
        return self.navigationController?.restorationIdentifier == "ItemDetailsNavigationController"
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath)
            let itemImageView = cell?.contentView.viewWithTag(1000) as! UIImageView
            itemImageView.image = UIImage(data: (itemDetails?.image)!)
        case 1...7:
            cell = tableView.dequeueReusableCellWithIdentifier("StandardFieldCell", forIndexPath: indexPath)
            let valueLabel = cell?.contentView.viewWithTag(1000) as! UILabel
            var valueText = ""
            switch indexPath.row {
                case 1: valueText = (itemDetails?.name)!
                case 2: valueText = (itemDetails?.series.name)!
                case 3: valueText = (itemDetails?.team.name)!
                case 4: valueText = (itemDetails?.no)!
                case 5: valueText = (itemDetails?.rarity.name)!
                case 6: valueText = (itemDetails?.status.name)!
                case 7: valueText = "\(((itemDetails?.quantity)! as Int32))"
                default: valueText = ""
            }
            valueLabel.text = valueText
            let fieldLabel = cell?.contentView.viewWithTag(1001) as! UILabel
            fieldLabel.text = itemDetailsKeyTitles[indexPath.row - 1] + ":"
        default:
            cell = nil
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 170
        default:
            return 32
        }
    }
    
    func didTapEdit() {
        let editItemNavVC = storyboard?.instantiateViewControllerWithIdentifier("EditItemNavigationController") as! UINavigationController
        let editItemVC = editItemNavVC.viewControllers[0] as! EditItemViewController
        editItemVC.itemDetails = itemDetails
        self.presentViewController(editItemNavVC, animated: true, completion: nil)
    }

    func didTapClose() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
