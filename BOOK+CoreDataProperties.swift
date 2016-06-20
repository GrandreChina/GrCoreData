//
//  BOOK+CoreDataProperties.swift
//  GrCoreData
//
//  Created by Grandre on 16/6/13.
//  Copyright © 2016年 革码者. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BOOK {

    @NSManaged var name: String?
    @NSManaged var price: NSNumber?

}
