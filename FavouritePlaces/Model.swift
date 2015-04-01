//
//  Model.swift
//  FavouritePlaces
//
//  Created by Adrian on 15.01.2015.
//  Copyright (c) 2015 Adrian. All rights reserved.
//

import UIKit
import CoreData

@objc(Model)
class Model: NSManagedObject {
    @NSManaged var item: String
    @NSManaged var quantity: String
    @NSManaged var info: String
    
}
