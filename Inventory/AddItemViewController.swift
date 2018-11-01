//
//  AddItemViewController.swift
//  Collectkins
//
//  Created by Consigliere on 6/16/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import UIKit

class AddItemViewController: AppBaseViewController {

    @IBOutlet var customAlertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customAlertView.layer.cornerRadius = 10
        customAlertView.layer.shadowOffset = CGSizeMake(0, 0)
        customAlertView.layer.shadowColor = UIColor.blackColor().CGColor
        customAlertView.layer.shadowRadius = 5
        customAlertView.layer.shadowOpacity = 0.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func didTapManual(sender: AnyObject) {
        let addItemManualNavVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddItemManualNavigationController") as! UINavigationController
        self.presentViewController(addItemManualNavVC, animated: true, completion: nil)
    }

    @IBAction func didTapScan(sender: AnyObject) {
        let scannerNavC = self.storyboard?.instantiateViewControllerWithIdentifier("BarcodeScannerNavigationController") as! UINavigationController
        self.presentViewController(scannerNavC, animated: true, completion: nil)
    }
    
}
