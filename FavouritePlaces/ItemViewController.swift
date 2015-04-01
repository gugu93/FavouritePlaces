//
//  ItemViewController.swift
//  FavouritePlaces
//
//  Created by Adrian on 15.01.2015.
//  Copyright (c) 2015 Adrian. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ItemViewController: UIViewController,
MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var textFieldItem: UITextField!
    @IBOutlet weak var textFieldQuantity: UITextField!
    @IBOutlet weak var textFieldInfo: UITextField!
    
    
    //Variables to update mode
    var item: String = ""
    var quantity: String = ""
    var info: String = ""
    
    var existingItem: NSManagedObject!
    
    // this function responsible for sending SMS if it can
    // body of message is name and cooraborate
    func launchMessageComposeViewController() {
        var name = textFieldItem.text as String
        var gpsX = textFieldQuantity.text as String
        var gpsY = textFieldInfo.text as String
        var bodyMessage = "\(name); X:\(gpsX); Y:\(gpsY)"
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.body = bodyMessage
            self.presentViewController(messageVC, animated: true, completion: nil)
        }
        else {
            println("User hasn't setup Messages.app \(bodyMessage)")
        }
    }
    
    // this function will be called after the user presses the cancel button or sends the text
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //if tap update mode fields will be filled
        if (existingItem != nil) {
            textFieldItem.text = item
            textFieldQuantity.text = quantity
            textFieldInfo.text = info
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func shareTap(sender: AnyObject) {
        launchMessageComposeViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tapCancel(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    //Save mode
    @IBAction func tapSave(sender: AnyObject) {
        //Connect to CoreData
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("List", inManagedObjectContext: contxt)
        
        //if existed item update it
        if (existingItem != nil) {
            existingItem.setValue(textFieldItem.text as String, forKey: "item")
            existingItem.setValue(textFieldInfo.text as String, forKey: "info")
            existingItem.setValue(textFieldQuantity.text as String, forKey: "quantity")
            
        // else create new object and save to CoreData
        } else {
            var newItem = Model(entity: en!, insertIntoManagedObjectContext: contxt)
            newItem.item = textFieldItem.text
            newItem.quantity = textFieldQuantity.text
            newItem.info = textFieldInfo.text
        }
            contxt.save(nil)
            //self.navigationController?.popToRootViewControllerAnimated(false)
            //self.navigationController?.popViewControllerAnimated(false, completion: nil)
            //after tap save button return to prev Controller
            self.navigationController?.popViewControllerAnimated(true)
        
    }
  


}
