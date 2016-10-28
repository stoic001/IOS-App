//
//  SavedData+CoreDataProperties.swift
//  
//
//  Created by Yuxiang Tang on 4/19/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SavedData {

    @NSManaged var cap: String?
    @NSManaged var change: String?
    @NSManaged var price: String?
    @NSManaged var stockName: String?
    @NSManaged var stockUrl: String?
    @NSManaged var symbol: String?
    @NSManaged var changeSign: String?

}
