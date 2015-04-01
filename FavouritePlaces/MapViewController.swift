//
//  MapViewController.swift
//  FavouritePlaces
//
//  Created by Adrian on 13.01.2015.
//  Copyright (c) 2015 Adrian. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation
extension Array {
    func forEach(doThis: (element: T) -> Void) {
        for e in self {
            doThis(element: e)
        }
    }
}
class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var myMap: MKMapView!
    var locationManager: CLLocationManager!

    var myList : Array<AnyObject> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //declarate long press gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
        //connect to CoreData
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName: "List")
        
        myList = context.executeFetchRequest(freq, error: nil)!
        //loop for, mark all favourite place on map
        for (index, element) in enumerate(myList) {
            println("Item \(index): \(element)")
            var name = element.valueForKey("item") as String
            var gpsX = element.valueForKey("quantity") as String
            var gpsY = element.valueForKey("info") as String
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double((gpsX as NSString).doubleValue), longitude: Double((gpsY as NSString).doubleValue))
            var newAnotation = MKPointAnnotation()
            newAnotation.coordinate = location
            //some code for debugging
            /*println("================")
            println(location.longitude)
            println(location.latitude)
            println("================")*/
            newAnotation.title = name
            myMap.addAnnotation(newAnotation)
            
        }
        longPress.minimumPressDuration = 1.0
        myMap.addGestureRecognizer(longPress)
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.myMap.setRegion(region, animated: true)
    }
   
    //function for locate user but don't work i don't know why
    @IBAction func TapLocate(sender: AnyObject) {
        //myMap.setCenterCoordinate(myMap.userLocation.location.coordinate, animated: true)
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    //function after long tap gesture
    //show pop up dialog where we can write name of place
    func action(gestureRecognizer:UIGestureRecognizer) {
        var name = String()
        var touchPoint = gestureRecognizer.locationInView(self.myMap)
        var newCoord:CLLocationCoordinate2D = myMap.convertPoint(touchPoint, toCoordinateFromView: self.myMap)
        var newAnotation = MKPointAnnotation()
        newAnotation.coordinate = newCoord
        var latitudeText:String = "\(newCoord.latitude)"
        var longitudeText:String = "\(newCoord.longitude)"
        //Create pop up dialog with...
        var alert = UIAlertController(title: NSLocalizedString("NEW_PLACE",comment:"New place"),
            message: NSLocalizedString("NEW_NAME_DESCRIPTION",comment:"Add a new favourite place"),
            preferredStyle: .Alert)
        //...save button...
        let saveAction = UIAlertAction(title: NSLocalizedString("SAVE",comment:"Save"),
            style: .Default) { (action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as UITextField
                name = textField.text
                newAnotation.title = name
                self.myMap.addAnnotation(newAnotation)
                let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                let contxt: NSManagedObjectContext = appDel.managedObjectContext!
                let en = NSEntityDescription.entityForName("List", inManagedObjectContext: contxt)
                var newItem = Model(entity: en!, insertIntoManagedObjectContext: contxt)
                newItem.item = name
                newItem.quantity = latitudeText
                newItem.info = longitudeText
                contxt.save(nil)
               
        }
        //...cancel button...
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL",comment:"Cancel"),
            style: .Default) { (action	: UIAlertAction!) -> Void in
        }
        //...field to write name...
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = NSLocalizedString("NAME",comment:"Name")
            
        }
        //...and two static textView
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.text = latitudeText
            textField.enabled = false
            
        })
        
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.text = longitudeText
            textField.enabled = false
            
        })
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
