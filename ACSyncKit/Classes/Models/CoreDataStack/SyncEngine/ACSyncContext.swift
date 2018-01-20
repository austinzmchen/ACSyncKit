//
//  ACSyncContext.swift
//  <?>App
//
//  Created by Austin Chen on 2016-05-26.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import CoreData

// sync context
public enum ACSyncPendingTaskDomain: String {
    case None, ProfileProcessing, SurveyProcessing, SurveyResponseUploading, ScheduleProcessing
}
public enum ACSyncPendingTaskPriority: Int {
    case low = 0, medium, high
}

open class ACSyncPendingTask: NSObject {
    open var taskDomain: ACSyncPendingTaskDomain = .None
    open var taskPriority: ACSyncPendingTaskPriority = .low
    open var taskAction: String = ""
}

open class ACSyncContext: NSObject {
    // remote context
    open var remoteSession: ACRemoteSession?
    
    // local CoreData context
    open var managedObjectContext: NSManagedObjectContext?
    
    // a list of to-do items
    open var pendingTasks: [ACSyncPendingTask] = []
}

// serializing ACSyncContext
extension ACSyncContext {
    public convenience init (remoteSession: ACRemoteSession?, managedObjectContext: NSManagedObjectContext?) {
        self.init()
        self.remoteSession = remoteSession
        self.managedObjectContext = managedObjectContext
    }
    
    public convenience init?(coder decoder: NSCoder) {
        self.init()
        if let pt = decoder.decodeObject(forKey: "pendingTasks") as? [ACSyncPendingTask] {
            self.pendingTasks = pt
        }
    }
    
    open func encodeWithCoder(_ coder: NSCoder) {
        coder.encode(self.pendingTasks, forKey: "pendingTasks")
    }
}
