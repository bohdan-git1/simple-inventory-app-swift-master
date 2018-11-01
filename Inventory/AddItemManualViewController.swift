//
//  AddItemManualViewController.swift
//  Collectkins
//
//  Created by Consigliere on 6/14/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import UIKit
import CoreData

class AddItemManualViewController: AppBaseViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var appDelegate: AppDelegate!
    var itemImage: UIImage?
    
    var criteriaData: [Int: [AppBaseMO]] = [:]
    
    var itemDetailsKeyTitles: [String] = ["Name", "Series", "Team", "Item #", "Rarity", "Status", "Quantity"]
    
    var itemNumberDefault: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        criteriaData[2] = Global.Data.series
        criteriaData[3] = Global.Data.teams
        criteriaData[5] = Global.Data.rarities
        criteriaData[6] = Global.Data.statuses
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let screenSize = UIScreen.mainScreen().bounds
        if let backgroundImage = UIImage(named: "Background-\(Int(screenSize.width))x\(Int(screenSize.height))") {
            self.tableView.backgroundView = UIImageView(image: backgroundImage)
        }
        
        itemImage = nil
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddItemManualViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        registerForKeyboardNotifications()
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
            if itemImage != nil {
                itemImageView.image = itemImage
            }
        case 1...7:
            cell = tableView.dequeueReusableCellWithIdentifier("StandardFieldCell", forIndexPath: indexPath)
            let fieldLabel = cell?.contentView.viewWithTag(1001) as! UILabel
            fieldLabel.text = itemDetailsKeyTitles[indexPath.row - 1] + ":"
            let textField = cell?.contentView.viewWithTag(1000) as! UITextField
            textField.delegate = self
            
            if [2, 3, 5, 6].contains(indexPath.row) {
                let pickerView = UIPickerView()
                pickerView.tag = indexPath.row
                pickerView.delegate = self
                textField.inputView = pickerView
            } else if indexPath.row == 4 {
                textField.keyboardType = .NumbersAndPunctuation
                if itemNumberDefault != "" {
                    textField.text = itemNumberDefault
                }
            } else if indexPath.row == 7 {
                textField.keyboardType = .NumberPad
            }
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
            return 40
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return criteriaData[pickerView.tag]!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return criteriaData[pickerView.tag]![row].stringValue()
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: pickerView.tag, inSection: 0))
        let textField = cell?.contentView.viewWithTag(1000) as! UITextField
        textField.text = criteriaData[pickerView.tag]![row].stringValue()
        
        // if series picker view
        if pickerView.tag == 2 {
            let series = criteriaData[2]![row] as! SeriesMO
            criteriaData[3] = Array(series.teams)
            let teamsCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))
            let textFieldTeam = teamsCell?.contentView.viewWithTag(1000) as! UITextField
            textFieldTeam.text = criteriaData[3]![0].stringValue()
            (textFieldTeam.inputView as! UIPickerView).selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.inputView is UIPickerView {
            return false
        }
        return true
    }
    
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        
        if notification.name == UIKeyboardWillHideNotification {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.inputView is UIPickerView && textField.text!.isEmpty {
            textField.text = criteriaData[textField.inputView!.tag]![0].stringValue()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func didTapAddImage(sender: AnyObject) {
        let alertController = UIAlertController(title: "Collectkins", message: "Choose import source.", preferredStyle: .ActionSheet)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = sender.bounds
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { alert in alertController.dismissViewControllerAnimated(true, completion: nil) }))
        alertController.addAction(UIAlertAction(title: "Open Camera", style: .Default, handler: { alert in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .Camera
            picker.cameraCaptureMode = .Photo
            self.presentViewController(picker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Open Photo Library", style: .Default, handler: { alert in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        // do something interesting here!
        itemImage = newImage
        tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func validateInputs() -> Bool {
        let textFieldName = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        let alertController = UIAlertController(title: "Warning", message: "", preferredStyle: .Alert)
        if textFieldName.text!.isEmpty {
            alertController.message = "Please fill name field."
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { alert in textFieldName.becomeFirstResponder() }))
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        let textFieldSeries = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        if textFieldSeries.text!.isEmpty {
            alertController.message = "Please choose series field."
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { alert in textFieldSeries.becomeFirstResponder() }))
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        let textFieldTeam = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        if textFieldTeam.text!.isEmpty {
            alertController.message = "Please choose team field."
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { alert in textFieldTeam.becomeFirstResponder() }))
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        let textFieldItemNumber = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        if textFieldItemNumber.text!.isEmpty {
            alertController.message = "Please fill item # field."
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { alert in textFieldItemNumber.becomeFirstResponder() }))
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        let textFieldRarity = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        if textFieldRarity.text!.isEmpty {
            alertController.message = "Please choose rarity field."
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { alert in textFieldRarity.becomeFirstResponder() }))
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        let textFieldStatus = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 6, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        if textFieldStatus.text!.isEmpty {
            alertController.message = "Please choose status field."
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { alert in textFieldStatus.becomeFirstResponder() }))
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        let textFieldQuantity = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        if textFieldQuantity.text!.isEmpty {
            alertController.message = "Please fill quantity field."
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { alert in textFieldQuantity.becomeFirstResponder() }))
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
//        if !self.isItemImageValid() {
//            alertController.message = "Please choose image."
//            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(alertController, animated: true, completion: nil)
//            return false
//        }
        
        return true
    }
    
    func isItemImageValid() -> Bool {
        return itemImage != nil
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func didTapSave(sender: AnyObject) {
        if validateInputs() == false {
            return
        }
        
        let inventoryItem = NSEntityDescription.insertNewObjectForEntityForName("InventoryItem", inManagedObjectContext: appDelegate.cdController.backgroundContext!) as! InventoryItemMO
        
        let itemImageView = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.contentView.viewWithTag(1000) as! UIImageView
        let textFieldName = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        let textFieldSeries = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        let pickerViewSeries = textFieldSeries.inputView as! UIPickerView
        let textFieldTeam = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        let pickerViewTeam = textFieldTeam.inputView as! UIPickerView
        let textFieldItemNumber = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        let textFieldRarity = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        let pickerViewRarity = textFieldRarity.inputView as! UIPickerView
        let textFieldStatus = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 6, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        let pickerViewStatus = textFieldStatus.inputView as! UIPickerView
        let textFieldQuantity = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0))?.contentView.viewWithTag(1000) as! UITextField
        
        inventoryItem.name = textFieldName.text!
        inventoryItem.no = textFieldItemNumber.text!
        inventoryItem.quantity = Int32(textFieldQuantity.text!)!
        inventoryItem.image = NSData(data: UIImageJPEGRepresentation(itemImageView.image!, 1.0)!)
        (criteriaData[2]![pickerViewSeries.selectedRowInComponent(0)] as! SeriesMO).inventoryItems.insert(inventoryItem)
        (criteriaData[3]![pickerViewTeam.selectedRowInComponent(0)] as! TeamMO).inventoryItems.insert(inventoryItem)
        (criteriaData[5]![pickerViewRarity.selectedRowInComponent(0)] as! RarityMO).inventoryItems.insert(inventoryItem)
        (criteriaData[6]![pickerViewStatus.selectedRowInComponent(0)] as! StatusMO).inventoryItems.insert(inventoryItem)
        
        switch appDelegate.cdController.saveContext(appDelegate.cdController.backgroundContext!) {
        case 0:
            let alertController = UIAlertController(title: "Collectkins", message: "Item added successfully.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { alert in
                self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
            }))
            presentViewController(alertController, animated: true, completion: nil)
            break
        case 133021:
            // NSConstraintConflict
            let alertController = UIAlertController(title: "Collectkins", message: "This item # already exists.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            break
        default:
            // Other error
            let alertController = UIAlertController(title: "Collectkins", message: "Unknown error occured.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

