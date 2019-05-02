//
//  ACRemoteRecordSyncableType.swift
//  ACSyncKit
//
//  Created by achen2 on 2019-05-02.
//

import Foundation
import CoreData

public protocol ACRemoteRecordSyncableType {
    var id: String { get }
}

public typealias ACSyncableKeyValuePairType = (key: String, value: AnyObject?)

public enum ACRemoteRecordChange<T: ACRemoteRecordSyncableType> {
    case found(T, NSManagedObjectID)
    case inserted(T, NSManagedObjectID)
    case removed
    
    public var isInserted: Bool {
        switch self {
        case .inserted:
            return true
        default:
            return false
        }
    }
    public var isFound: Bool {
        switch self {
        case .found:
            return true
        default:
            return false
        }
    }
    public var isRemoved: Bool {
        switch self {
        case .removed:
            return true
        default:
            return false
        }
    }
    
    public var managedObjectID: NSManagedObjectID? {
        switch self {
        case .found(_, let managedObjectID):
            return managedObjectID
        case .inserted(_, let managedObjectID):
            return managedObjectID
        default:
            return nil
        }
    }
}
