//
//  ACBase+CoreDataProperties.swift
//  <?>App
//
//  Created by Austin Chen on 2017-04-05.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import CoreData

extension ACBase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ACBase> {
        return NSFetchRequest<ACBase>(entityName: "ACBase")
    }

    @NSManaged public var id: String
    @NSManaged public var order: Int
}
