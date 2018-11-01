//
//  StatusMO.swift
//  Collectkins
//
//  Created by Consigliere on 6/22/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import Foundation
import CoreData

class StatusMO: AppBaseMO {
    @NSManaged var name: String
    @NSManaged var inventoryItems: Set<InventoryItemMO>
    
    static func findAll() -> [StatusMO]? {
        let fetchRequest = NSFetchRequest(entityName: "Status")
        do {
            let results = try _appDelegate.cdController.backgroundContext!.executeFetchRequest(fetchRequest)
            return results as? [StatusMO]
            
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
