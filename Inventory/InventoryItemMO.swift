//
//  InventoryItemMO.swift
//  Collectkins
//
//  Created by Consigliere on 6/15/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class InventoryItemMO: AppBaseMO {
    @NSManaged var no: String
    @NSManaged var name: String
    @NSManaged var quantity: Int32
    @NSManaged var image: NSData
    
    @NSManaged var series: SeriesMO
    @NSManaged var team: TeamMO
    @NSManaged var rarity: RarityMO
    @NSManaged var status: StatusMO
    
    static func getItemDetails(WithItemNumber itemNo: String) -> InventoryItemMO? {
        // Fetching
        let fetchRequest = NSFetchRequest(entityName: "InventoryItem")
        
        // Create Predicate
        let predicate = NSPredicate(format: "%K LIKE[c] %@", "no", itemNo)
        fetchRequest.predicate = predicate
        
        // Execute Fetch Request
        do {
            let results = try _appDelegate.cdController.backgroundContext!.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                return results[0] as? InventoryItemMO
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return nil
    }
}
