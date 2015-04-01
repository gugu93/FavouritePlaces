//
//  TableViewController.swift
//  FavouritePlaces
//
//  Created by Adrian on 15.01.2015.
//  Copyright (c) 2015 Adrian. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    
    //List of favourite places
    var myList : Array<AnyObject> = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func viewDidAppear(animated: Bool) {
        //Connect to CoreData
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName: "List")
        
        myList = context.executeFetchRequest(freq, error: nil)!
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //Mode for update, if tap exsisted item
        if segue.identifier? == "update" {
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            var selectedItem: NSManagedObject = myList[indexPath.row] as NSManagedObject
            let IVC: ItemViewController = segue.destinationViewController as ItemViewController
            //Transfer selected data to ItemViewController
            IVC.item = selectedItem.valueForKey("item") as String
            IVC.quantity = selectedItem.valueForKey("quantity") as String
            IVC.info = selectedItem.valueForKey("info") as String
            IVC.existingItem = selectedItem
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        //Delete data
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let tv = tableView {
                context.deleteObject(myList[indexPath!.row] as NSManagedObject)
                myList.removeAtIndex(indexPath!.row)
                tv.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            var error: NSError? = nil
            if !context.save(&error) {
                abort()
            }
        }
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return myList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell {
        let CellID: NSString = "Cell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellID) as UITableViewCell
        if let ip = indexPath {
            //Setting data to view
            var data: NSManagedObject = myList[ip.row] as NSManagedObject
            cell.textLabel.text = data.valueForKeyPath("item") as? String
            var qnt = data.valueForKey("quantity") as String
            var inf = data.valueForKey("info") as String
            cell.detailTextLabel?.text = "X: \(qnt)  Y: \(inf)"
            
        }
        return cell
    }


}
