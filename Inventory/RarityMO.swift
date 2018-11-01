//
//  RarityMO.swift
//  Collectkins
//
//  Created by Consigliere on 6/22/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import Foundation
import CoreData

class RarityMO: AppBaseMO {
    @NSManaged var name: String
    @NSManaged var inventoryItems: Set<InventoryItemMO>
    
    static func findAll() -> [RarityMO]? {
        let fetchRequest = NSFetchRequest(entityName: "Rarity")
        do {
            let results = try _appDelegate.cdController.backgroundContext!.executeFetchRequest(fetchRequest)
            return results as? [RarityMO]
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return nil
    }
    
    override func stringValue() -> String? {
        return self.name
    }
}
