//
//  ACBase+CoreDataClass.swift
//  <?>App
//
//  Created by Austin Chen on 2017-04-05.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import CoreData

@objc(ACBase)
open class ACBase: NSManagedObject {
    
    open func saveSyncableProperties(fromSyncable syncable: ACRemoteRecordSyncableType) {
        print("to be subclassed")
    }
}
