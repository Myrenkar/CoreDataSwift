//
//  Item+CoreDataProperties.swift
//  CD-Grocery-Images
//
//  Created by Piotr Torczyski on 08/02/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var image: NSData?
    @NSManaged var name: String?
    @NSManaged var note: String?
    @NSManaged var qty: String?

}
