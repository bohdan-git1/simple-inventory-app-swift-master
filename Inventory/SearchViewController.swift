//
//  SearchViewController.swift
//  Collectkins
//
//  Created by Consigliere on 6/14/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: AppBaseViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var appDelegate: AppDelegate!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textFieldSearchQuery: UITextField!
    @IBOutlet var textFieldSeries: UITextField!
    @IBOutlet var textFieldTeam: UITextField!
    @IBOutlet var textFieldRarity: UITextField!
    @IBOutlet var textFieldStatus: UITextField!
    
    var activeTextField: UITextField?
    
    var criteriaData: [Int: [AppBaseMO]] = [:]
    var criteriaTextFields: [Int: UITextField] = [:]
    let criteriaTextsForAll = [
        1: "All Seasons",
        2: "All Teams",
        3: "All Rarities",
        4: "All Status'"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        _loadCriteriaData()
        
        criteriaTextFields[1] = textFieldSeries
        criteriaTextFields[2] = textFieldTeam
        criteriaTextFields[3] = textFieldRarity
        criteriaTextFields[4] = textFieldStatus
        
        textFieldSearchQuery.delegate = self
        
        let pickerViewSeries = UIPickerView()
        pickerViewSeries.tag = 1
        pickerViewSeries.delegate = self
        textFieldSeries.inputView = pickerViewSeries
        textFieldSeries.delegate = self
        textFieldSeries.text = criteriaTextsForAll[1]
        
        let pickerViewTeam = UIPickerView()
        pickerViewTeam.tag = 2
        pickerViewTeam.delegate = self
        textFieldTeam.inputView = pickerViewTeam
        textFieldTeam.delegate = self
        textFieldTeam.text = criteriaTextsForAll[2]
        
        let pickerViewRarity = UIPickerView()
        pickerViewRarity.tag = 3
        pickerViewRarity.delegate = self
        textFieldRarity.inputView = pickerViewRarity
        textFieldRarity.delegate = self
        textFieldRarity.text = criteriaTextsForAll[3]
        
        let pickerViewStatus = UIPickerView()
        pickerViewStatus.tag = 4
        pickerViewStatus.delegate = self
        textFieldStatus.inputView = pickerViewStatus
        textFieldStatus.delegate = self
        textFieldStatus.text = criteriaTextsForAll[4]
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func _loadCriteriaData() {
        criteriaData[1] = Global.Data.series
        criteriaData[2] = Global.Data.teams
        criteriaData[3] = Global.Data.rarities
        criteriaData[4] = Global.Data.statuses
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
    
    override func viewWillAppear(animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return criteriaData[pickerView.tag]!.count + 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? criteriaTextsForAll[pickerView.tag] : criteriaData[pickerView.tag]?[row - 1].stringValue()
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let textField = criteriaTextFields[pickerView.tag]
        if row == 0 {
            textField?.text = criteriaTextsForAll[pickerView.tag]
        } else {
            textField?.text = criteriaData[pickerView.tag]?[row - 1].stringValue()
        }
        
        // if series picker view
        if pickerView.tag == 1 {
            if row == 0 {
                criteriaData[2] = TeamMO.findAll()
            } else {
                let series = criteriaData[1]![row - 1] as! SeriesMO
                criteriaData[2] = Array(series.teams)
            }
            criteriaTextFields[2]?.text = criteriaTextsForAll[2]
            (criteriaTextFields[2]?.inputView as! UIPickerView).selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField === textFieldSeries || textField === textFieldTeam || textField === textFieldRarity || textField === textFieldStatus {
            return false
        }
        return true
    }
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.scrollEnabled = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if activeTextField != nil
        {
            if (!CGRectContainsPoint(aRect, activeTextField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeTextField!.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.scrollEnabled = false
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    @IBAction func didTapSearchButton(sender: AnyObject) {
        // Fetching
        let fetchRequest = NSFetchRequest(entityName: "InventoryItem")
        
        // Create Predicate
        let searchQuery = textFieldSearchQuery.text!.isEmpty ? "*" : "*" + textFieldSearchQuery.text! + "*"
        let series  = textFieldSeries.text! == "All Seasons" ? "*" : textFieldSeries.text!
        let team    = textFieldTeam.text! == "All Teams" ? "*" : textFieldTeam.text!
        let rarity  = textFieldRarity.text! == "All Rarities" ? "*" : textFieldRarity.text!
        let status  = textFieldStatus.text! == "All Status'" ? "*" : textFieldStatus.text!
        let predicate = NSPredicate(format: "%K LIKE[c] %@ AND %K LIKE %@ AND %K LIKE %@ AND %K LIKE %@ AND %K LIKE %@", "name", searchQuery, "series.name", series, "team.name", team, "rarity.name", rarity, "status.name", status)
        fetchRequest.predicate = predicate
        
        // Execute Fetch Request
        do {
            let searchResultsVC = self.storyboard?.instantiateViewControllerWithIdentifier("SearchResultsViewController") as! SearchResultsViewController
            searchResultsVC.searchResults = try appDelegate.cdController.backgroundContext!.executeFetchRequest(fetchRequest) as! [InventoryItemMO]
            self.navigationController?.pushViewController(searchResultsVC, animated: true)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
}

