//
//  ScanViewController.swift
//  Collectkins
//
//  Created by Consigliere on 6/16/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import UIKit
import CoreData
import RSBarcodes_Swift

class ScanViewController: RSCodeReaderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.focusMarkLayer.strokeColor = UIColor.redColor().CGColor
        self.cornersLayer.strokeColor = UIColor.yellowColor().CGColor
        
        self.barcodesHandler = { barcodes in
            if barcodes.count > 0 {
                if let itemDetails = InventoryItemMO.getItemDetails(WithItemNumber: barcodes[0].stringValue) {
                    let alertController = UIAlertController(title: "Notes", message: "This item already exists. Do you want to edit details?", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { alert in
                        let editItemNavC = self.storyboard?.instantiateViewControllerWithIdentifier("EditItemNavigationController") as! UINavigationController
                        let editItemVC = editItemNavC.viewControllers[0] as! EditItemViewController
                        editItemVC.itemDetails = itemDetails
                        self.presentViewController(editItemNavC, animated: true, completion: nil)
                    }))
                    alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: { alert in
                        let itemDetailsNavC = self.storyboard?.instantiateViewControllerWithIdentifier("ItemDetailsNavigationController") as! UINavigationController
                        let itemDetailsVC = itemDetailsNavC.viewControllers[0] as! ItemDetailsViewController
                        itemDetailsVC.itemDetails = itemDetails
                        self.presentViewController(itemDetailsNavC, animated: true, completion: nil)
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let addItemManualNavC = self.storyboard?.instantiateViewControllerWithIdentifier("AddItemManualNavigationController") as! UINavigationController
                    let addItemManualVC = addItemManualNavC.viewControllers[0] as! AddItemManualViewController
                    addItemManualVC.itemNumberDefault = barcodes[0].stringValue
                    self.presentViewController(addItemManualNavC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func didTapBack(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
