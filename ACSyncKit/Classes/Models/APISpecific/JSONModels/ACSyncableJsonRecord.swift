//
//  ACSyncableJsonRecord.swift
//  <?>App
//
//  Created by Austin Chen on 2016-05-19.
//

import Foundation
import ObjectMapper

public typealias ACSyncableKeyValuePairType = (key: String, value: AnyObject?)

open class ACSyncableJsonRecord: NSObject, Mappable, ACRemoteRecordSyncableType {
    
    // MARK: app specific stored properties
    open var id: String = ""
    
    var order: Int = -1 // optional, ordering info
    var relationshipId: Int64? // optional, for adding relationship to parent

    override init() {}
    required public init?(map: Map) {}
    
    open func mapping(map: Map) {
        id <- map["Id"]
    }
}
