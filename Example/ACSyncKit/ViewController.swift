//
//  ViewController.swift
//  ACSyncKit
//
//  Created by austinzmchen on 01/19/2018.
//  Copyright (c) 2018 austinzmchen. All rights reserved.
//

import UIKit
import ACSyncKit
import CoreData

class ViewController: UIViewController {
    
    let syncer = ACSyncCoordinator(remoteSession: ACRemoteSession(domain: "tmpDomain"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let context = CoreDataStack.shared.persistentContainer.viewContext
        
//        syncer.syncAll { (success, results, error) in
//            print(success)
//        }
        let context = syncer.coreDataStack.mainManagedObjectContext
        
        
        // add entities
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        user.setValue("Tommy", forKeyPath: "name")
        user.setValue(22, forKeyPath: "age")
        
        
        let allKeys = Array(user.entity.attributesByName.keys)
        let dict = user.dictionaryWithValues(forKeys: allKeys)
        print(dict)
        //        let keys = User.entity().attributesByName.keys
        
        let ks = Array(user.entity.relationshipsByName.keys)
        let dict2 = user.dictionaryWithValues(forKeys: ks)
        print(dict2)
    }
    
    func abc() {
//        let starship = try! JSONDecoder().decode(Starship_Simple.self, from: starshipStr.data(using: .utf8)!)
//
//        if let type = NSClassFromString("User") {
//            sync([starship], toManagedObjectType: User.self)
//        }
        
        let starship = try! JSONSerialization.jsonObject(with: starshipStr.data(using: .utf8)!,
                                                         options: []) as! [String: Any]
        sync([starship], toManagedObjectType: User.self)
    }
//    func store<T: ACRemoteRecordSyncableType, S: ACManagedObject>(_ items: [T], toManagedObjectType type: S.Type) -> [NSManagedObjectID]? {
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
//                object.saveSyncableProperties(fromSyncable: rRecord)
                
                let allKeys = Array(User.entity().attributesByName.keys)
                let dict = User.entity().dictionaryWithValues(forKeys: allKeys)
                print(dict)
                for (key, value) in dict {
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
    
    var starshipStr = """
        {
            "name": "Vulcan",
            "capitan": {
                "name": "Paul",
                "age": 44
            },
            "crews": [
                {
                    "name": "Crew One",
                    "age": 30
                },
                {
                    "name": "Crew Two",
                    "age": 22
                }
            ],
            "weight": 10,
            "speed": 100
        }
    """
}

typealias JsonPairs = Dictionary<String, Any>

extension Dictionary: ACRemoteRecordSyncableType
    where Key == String, Value == Any
{
    public var id: String {
        return (self["id"] as? String) ?? ""
    }
}



struct Starship_Simple: Codable, ACRemoteRecordSyncableType {
    var id: String
    var name: String
    var weight: Float
    //    var capitan: Crew
    //    var crews: [Crew]
    var speed: Float
}
