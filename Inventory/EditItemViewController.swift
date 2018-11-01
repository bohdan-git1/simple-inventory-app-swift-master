//
//  EditItemViewController.swift
//  Collectkins
//
//  Created by Consigliere on 6/16/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import UIKit
import CoreData

class EditItemViewController: AddItemManualViewController {
    
    var itemDetails: InventoryItemMO?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath)
            let itemImageView = cell?.contentView.viewWithTag(1000) as! UIImageView
            itemImageView.image = itemImage != nil ? itemImage : UIImage(data: (itemDetails?.image)!)
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
                
                switch indexPath.row {
                case 2:
                    pickerView.selectRow((criteriaData[indexPath.row]?.indexOf((itemDetails?.series)!))!, inComponent: 0, animated: true)
                case 3:
                    criteriaData[indexPath.row] = Array(itemDetails!.series.teams)
                    pickerView.selectRow((criteriaData[indexPath.row]?.indexOf((itemDetails?.team)!))!, inComponent: 0, animated: true)
                case 5:
                    pickerView.selectRow((criteriaData[indexPath.row]?.indexOf((itemDetails?.rarity)!))!, inComponent: 0, animated: true)
                case 6:
                    pickerView.selectRow((criteriaData[indexPath.row]?.indexOf((itemDetails?.status)!))!, inComponent: 0, animated: true)
                default:
                    break
                }
            } else if indexPath.row == 4 {
                textField.keyboardType = .NumbersAndPunctuation
            } else if indexPath.row == 7 {
                textField.keyboardType = .NumberPad
            }
            
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
            
            textField.text = valueText
        default:
            cell = nil
        }
        return cell!
    }
    
    override func isItemImageValid() -> Bool {
        return true
    }
    
    override func didTapSave(sender: AnyObject) {
        if validateInputs() == false {
            return
        }
        
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
        
        itemDetails!.name = textFieldName.text!
        itemDetails!.no = textFieldItemNumber.text!
        itemDetails!.quantity = Int32(textFieldQuantity.text!)!
        itemDetails!.image = NSData(data: UIImageJPEGRepresentation(itemImageView.image!, 1.0)!)
        
        itemDetails?.series.inventoryItems.remove(itemDetails!)
        (criteriaData[2]![pickerViewSeries.selectedRowInComponent(0)] as! SeriesMO).inventoryItems.insert(itemDetails!)
        itemDetails?.team.inventoryItems.remove(itemDetails!)
        (criteriaData[3]![pickerViewTeam.selectedRowInComponent(0)] as! TeamMO).inventoryItems.insert(itemDetails!)
        itemDetails?.rarity.inventoryItems.remove(itemDetails!)
        (criteriaData[5]![pickerViewRarity.selectedRowInComponent(0)] as! RarityMO).inventoryItems.insert(itemDetails!)
        itemDetails?.status.inventoryItems.remove(itemDetails!)
        (criteriaData[6]![pickerViewStatus.selectedRowInComponent(0)] as! StatusMO).inventoryItems.insert(itemDetails!)
        
        appDelegate.cdController.saveContext(appDelegate.cdController.backgroundContext!)
        
        let alertController = UIAlertController(title: "Collectkins", message: "Item updated successfully.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { alert in
            self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(alertController, animated: true, completion: nil)
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
