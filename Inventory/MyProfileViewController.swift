//
//  MyProfileViewController.swift
//  Collectkins
//
//  Created by Consigliere on 6/19/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import UIKit

class MyProfileViewController: AppBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var fieldTitles: [String] = ["Full Name", "Username", "Email", "Status"]
    var fieldValues: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        fieldValues = ["Mr. Higgie", "mrhiggie", "mr.higgie@gmail.com", "Private"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StandardCell", forIndexPath: indexPath)
        cell.textLabel?.text = fieldTitles[indexPath.row]
        cell.detailTextLabel?.text = fieldValues[indexPath.row]
        return cell
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
