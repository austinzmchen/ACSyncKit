//
//  ViewControllerPlus.swift
//  ACSyncKit_Example
//
//  Created by achen2 on 2019-05-02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ACSyncKit
import CoreData

extension ViewController {
    
    func sync<S: ACManagedObject>(_ items: [JsonPairs], toManagedObjectType type: S.Type) {
        guard let managedObjectContext = Optional.some(syncer.coreDataStack.syncManagedObjectContext) else {
            return
        }
        
        var objectIDs: [NSManagedObjectID] = []
        
        managedObjectContext.performAndWait({
            let updateData: (ACRemoteRecordSyncableType, NSManagedObjectID) -> Void = { (remoteRecord, managedObjectID) in
                guard let object = managedObjectContext.object(with: managedObjectID) as? S,
                    let rRecord = remoteRecord as? JsonPairs else
                {
                    return
                }
                object.saveSyncableProperties(fromSyncable: rRecord)
                
                let allKeys = Array(User.entity().attributesByName.keys)
                let dict = User.entity().dictionaryWithValues(forKeys: allKeys)
                print(dict)
                for (key, _) in dict {
                    guard let r = rRecord as? [String: Any] else {continue}
                    object.setValue(r[key], forKey: key)
                }
            }
            
            let changes : [ACRemoteRecordChange<JsonPairs>] = managedObjectContext.findOrInsert(items, toManagedObjectType: S.self, byUniqueKey: "id",
                                                                                                removeLocalItemsIfNotFoundInRemote: true)
            for change in changes {
                switch change {
                case .found(let remoteRecord, let managedObjectID):
                    updateData(remoteRecord, managedObjectID)
                    break
                case .inserted(let remoteRecord, let managedObjectID):
                    updateData(remoteRecord, managedObjectID)
                    break
                default:
                    break
                }
                
                guard let objectID = change.managedObjectID else { continue }
                objectIDs.append(objectID)
            }
            
            if (managedObjectContext.hasChanges) {
                try! managedObjectContext.save() // TODO: for production, change try! to catch
            }
        })
    }
}
