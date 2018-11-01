//
//  AppDelegate.swift
//  Collectkins
//
//  Created by Consigliere on 6/14/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var cdController: CoreDataController = {
        let cdc = CoreDataController()
        return cdc
    }()
    
    lazy var cdStore: CoreDataStore = {
        let cdstore = CoreDataStore()
        return cdstore
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        if !self.validateSeriesData() {
            self.seedData()
        }
        
        loadData()
        
        let tintColor = UIColor(red: 250.0/255, green: 48.0/255, blue: 252.0/255, alpha: 1.0)
        self.window?.tintColor = tintColor
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: tintColor], forState: .Selected)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /* Custom functions */
    
    func documentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
    
    func validateSeriesData() -> Bool {
        print(self.documentPath());
        
        let fetchRequest = NSFetchRequest(entityName: "Series")
        
        do {
            let results = try self.cdController.backgroundContext!.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                return true
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return false
    }
    
    func seedData() {
        // teams
        var teams: [TeamMO] = []
        for teamName in Constants.SearchCriteriaOptions.teams {
            let team = NSEntityDescription.insertNewObjectForEntityForName("Team", inManagedObjectContext: self.cdController.backgroundContext!) as! TeamMO
            team.name = teamName
            teams.append(team)
            cdController.saveContext(cdController.backgroundContext!)
        }
        
        // series
        var series = NSEntityDescription.insertNewObjectForEntityForName("Series", inManagedObjectContext: self.cdController.backgroundContext!) as! SeriesMO
        series.name = "Season 1"
        series.teams = [teams[0], teams[1], teams[2], teams[3], teams[4], teams[5], teams[6], teams[7]]
        cdController.saveContext(cdController.backgroundContext!)
        
        series = NSEntityDescription.insertNewObjectForEntityForName("Series", inManagedObjectContext: self.cdController.backgroundContext!) as! SeriesMO
        series.name = "Season 2"
        series.teams = [teams[3], teams[2], teams[1], teams[8], teams[0], teams[9], teams[10], teams[11]]
        cdController.saveContext(cdController.backgroundContext!)
        
        series = NSEntityDescription.insertNewObjectForEntityForName("Series", inManagedObjectContext: self.cdController.backgroundContext!) as! SeriesMO
        series.name = "Season 3"
        series.teams = [teams[2], teams[3], teams[9], teams[12], teams[0], teams[13], teams[10], teams[14]]
        cdController.saveContext(cdController.backgroundContext!)
        
        series = NSEntityDescription.insertNewObjectForEntityForName("Series", inManagedObjectContext: self.cdController.backgroundContext!) as! SeriesMO
        series.name = "Season 4"
        series.teams = [teams[0], teams[2], teams[3], teams[15], teams[16], teams[17], teams[9], teams[18], teams[19]]
        cdController.saveContext(cdController.backgroundContext!)
        
        series = NSEntityDescription.insertNewObjectForEntityForName("Series", inManagedObjectContext: self.cdController.backgroundContext!) as! SeriesMO
        series.name = "Season 5"
        series.teams = [teams[20], teams[17], teams[21], teams[9], teams[2], teams[3], teams[22], teams[23]]
        cdController.saveContext(cdController.backgroundContext!)
        
        // rarities
        for rarityName in Constants.SearchCriteriaOptions.rarities {
            let rarity = NSEntityDescription.insertNewObjectForEntityForName("Rarity", inManagedObjectContext: self.cdController.backgroundContext!) as! RarityMO
            rarity.name = rarityName
            cdController.saveContext(cdController.backgroundContext!)
        }
        
        // statuses
        for statusName in Constants.SearchCriteriaOptions.statuses {
            let status = NSEntityDescription.insertNewObjectForEntityForName("Status", inManagedObjectContext: self.cdController.backgroundContext!) as! StatusMO
            status.name = statusName
            cdController.saveContext(cdController.backgroundContext!)
        }
    }
    
    func loadData() {
        Global.Data.series      = SeriesMO.findAll()
        Global.Data.teams       = TeamMO.findAll()
        Global.Data.rarities    = RarityMO.findAll()
        Global.Data.statuses    = StatusMO.findAll()
    }


}

