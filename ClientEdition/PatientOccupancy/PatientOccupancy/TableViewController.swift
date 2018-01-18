//
//  TableViewController.swift
//  PatientOccupancy
//
//  Created by Abhi Gupta on 2015-08-14.
//  Copyright (c) 2015 AbhiGupta. All rights reserved.
//

import UIKit

class TableViewController: PFQueryTableViewController{
    
    @IBAction func logOut(sender: AnyObject) {
        var alert = UIAlertController(title: "Log Out", message: "Checking Permissions", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            textField.keyboardAppearance = UIKeyboardAppearance.Light
            
        })
        let action = UIAlertAction(title: "Authorize",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = alert.textFields{
                    let theTextFields = textFields as! [UITextField]
                    let enteredText = theTextFields[0].text
                    var currentUser = PFUser.currentUser()
                    PFUser.logInWithUsernameInBackground(currentUser.username, password:enteredText) {
                        (user: PFUser?, error: NSError?) -> Void in
                        if user != nil {
                            PFUser.logOut()
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
                            self!.presentViewController(vc, animated: true, completion: nil)
                        }
                    }
                }
            })
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
            
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Configure the PFQueryTableView
        self.parseClassName = "Patients"
        self.textKey = "name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    func getWaitedTime(arrivedTime: NSDate, currentWaitedTime: Double) -> Double? {
        let UTCDate = NSDate()
        let minutes = Double(UTCDate.minutesFrom(arrivedTime))
        if minutes > currentWaitedTime {
            return minutes
        } else {
            return nil
        }
    }
    
    // Define the query that will provide the data for the table view
    // Everytime user pulls down to refresh, this method is called to refresh the data
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Patients")
        query.orderByDescending("waitedTime")
        
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [AnyObject]!, error: NSError!) -> Void in
//            if !(error != nil) {
//                for object in objects{
//                    if let data = object as? PFObject{
//                        //Set test to total (assuming self.test is Int)
//                        println(data["name"])}
//                }
//            }
//        }
        return query
    }
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    // Everytime user pulls down to refresh, this method is called to display data
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        navigationItem.title = "Patient Waiting List"
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.rowHeight = 100
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomTableViewCell!
        cell.backgroundColor = UIColor.clearColor()

        if cell == nil {
            cell = CustomTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let name = object?["name"] as? String {
            let nameArray = name.componentsSeparatedByString(" ")
            //cell?.textLabel?.text = name          // patient name
            if nameArray.count == 2 {
                cell.initialsIcon.text = (nameArray[0][0].capitalizeIt)+(nameArray[1][0].capitalizeIt)
                cell.firstName.text = nameArray[0].capitalizeIt
                cell.lastName.text = nameArray[1].capitalizeIt
            } else {
                cell.initialsIcon.text = (nameArray[0][0].capitalizeIt)
                cell.lastName.text = nameArray[0].capitalizeIt
            }
        }
        let col = "waitedTime"
        if let waitedTime = object![col] as! Double? {
            let val = round(waitedTime)
            let string = String(format:"%.0f", val)
            var textCol: UIColor = UIColor.whiteColor()
            cell.waitedTime.text = "\(string)"
            if val >= 0 && val <= 15 {
                textCol = UIColor(red: (162/255.0), green: (243/255.0), blue: (74/255.0), alpha: 1)
            } else if val > 15 && val <= 30 {
                textCol = UIColor(red: (239/255.0), green: (224/255.0), blue: (39/255.0), alpha: 1)
            } else if val > 30 {
                textCol = UIColor(red: (249/255.0), green: (82/255.0), blue: (102/255.0), alpha: 1)
            }
            cell.waitedTime.textColor = textCol
            cell.minute.textColor = textCol
            
            if let arrivedTime = object!.createdAt as? NSDate {
                if let newWaitedTime = getWaitedTime(arrivedTime, currentWaitedTime: waitedTime) {
                    object![col] = newWaitedTime
                    object?.saveEventually()
                }
            }
        }
        self.loadObjects()
        return cell
    }
    

   
}
