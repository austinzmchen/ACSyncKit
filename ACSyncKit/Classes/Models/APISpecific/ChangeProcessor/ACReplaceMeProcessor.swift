//
//  ACReplaceMeProcessorType.swift
//  <?>App
//
//  Created by Austin Chen on 2017-04-05.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import CoreData

protocol ACReplaceMeProcessorType: ACSyncableProcessorType {
}

@objc class ACReplaceMeProcessor: NSObject, ACReplaceMeProcessorType {
    
    let syncContext: ACSyncContext
    
    required init (context: ACSyncContext) {
        self.syncContext = context
    }
    
    func sync(_ completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ()) {
        
    }
}


fileprivate let kRemoteFetchSizeDefault: Int = 16
