//
//  SeriesMO.swift
//  Collectkins
//
//  Created by Consigliere on 6/22/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SeriesMO: AppBaseMO {
    @NSManaged var name: String
    @NSManaged var teams: Set<TeamMO>
    @NSManaged var inventoryItems: Set<InventoryItemMO>
    
    static func findAll() -> [SeriesMO]? {
        let fetchRequest = NSFetchRequest(entityName: "Series")
        do {
            let results = try _appDelegate.cdController.backgroundContext!.executeFetchRequest(fetchRequest)
            return results as? [SeriesMO]
            
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
