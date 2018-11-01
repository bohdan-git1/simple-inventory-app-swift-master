//
//  TeamMO.swift
//  Collectkins
//
//  Created by Consigliere on 6/22/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import Foundation
import CoreData

class TeamMO: AppBaseMO {
    @NSManaged var name: String
    @NSManaged var series: Set<SeriesMO>
    @NSManaged var inventoryItems: Set<InventoryItemMO>
    
    static func findAll() -> [TeamMO]? {
        let fetchRequest = NSFetchRequest(entityName: "Team")
        do {
            let results = try _appDelegate.cdController.backgroundContext!.executeFetchRequest(fetchRequest)
            return results as? [TeamMO]
            
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

