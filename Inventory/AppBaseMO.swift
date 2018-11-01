//
//  AppBaseMO.swift
//  Collectkins
//
//  Created by Consigliere on 6/22/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import Foundation
import CoreData

class AppBaseMO: NSManagedObject {
    
    static internal let _appDelegate = {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }()
    
    func stringValue() -> String? {
        return nil
    }
    
}
