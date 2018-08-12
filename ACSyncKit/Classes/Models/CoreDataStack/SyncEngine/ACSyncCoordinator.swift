//
//  ACSyncCoordinator.swift
//  <?>App
//
//  Created by Austin Chen on 2016-04-28.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public let ACSyncAllCompletedNotification = "kACSyncAllCompletedNotification"

public protocol ACSyncCoordinatorType  {
    func syncAll(_ completion: @escaping (_ success: Bool, _ synced: [Any]?, _ error: Error?) -> ())
}

open class ACSyncCoordinator: NSObject, ACSyncCoordinatorType {
    
    public let syncGroup: DispatchGroup = DispatchGroup()
    public var didSetup: Bool = false
    
    open var syncContext: ACSyncContext = ACSyncContext()
    open var appTerminateObserver: AnyObject? = nil
    
    fileprivate var observerTokens: [NSObjectProtocol] = [] //< The tokens registered with NSNotificationCenter
    
    // MARK - life cycle methods
    
    public init(remoteSession: ACRemoteSession) {
        super.init()
        
        self.registerValueTransformers()
        self.syncContext = ACSyncContext(remoteSession: remoteSession,
                                         managedObjectContext: self.coreDataStack.syncManagedObjectContext)
        self.didSetup = true
        self.setupContexts()
        
        appTerminateObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillTerminate, object: nil, queue: nil, using: { (notification) in
            do {
                try self.syncContext.managedObjectContext!.save()
            } catch let e {
                print("error: \(e.localizedDescription)")
            }
        })
    }
    
    public convenience init(remoteSession: ACRemoteSession, managedObjectContext: NSManagedObjectContext) {
        self.init(remoteSession: remoteSession)
        self.syncContext = ACSyncContext(remoteSession: remoteSession, managedObjectContext: managedObjectContext)
    }
    
    deinit {
        if let observer = appTerminateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK - instance methods
    
    open lazy var coreDataStack: ACCoreDataStackType = {
        return ACCoreDataStack()
    }()
    
    open func syncAll(_ completion: @escaping (_ success: Bool, _ synced: [Any]?, _ error: Error?) -> ()) {
        fatalError("Should be implemented by subclass")
    }
    
    /**
     eg. ValueTransformer.setValueTransformer(ACJsonTransformer<ACJsonReplaceMe>(),
            forName: NSValueTransformerName(rawValue: "kACJsonReplaceMeTransformer"))
     */
    open func registerValueTransformers() {
        // should only run once
        fatalError("Should be implemented by subclass")
    }
}

// MARK: - Context Owner -

extension ACSyncCoordinator: ContextOwnerType {
    /// The Sync Coordinator holds onto tokens used to register with the NSNotificationCenter.
    open func addObserverToken(_ token: NSObjectProtocol) {
        precondition(didSetup, "Did not call setup()")
        observerTokens.append(token)
    }
    open func removeAllObserverTokens() {
        precondition(didSetup, "Did not call setup()")
        observerTokens.removeAll()
    }
    
    open func processChangedLocalObjects(_ objects: [NSManagedObject]) {
        precondition(didSetup, "Did not call setup()")
        /*
        for cp in changeProcessors {
            cp.processChangedLocalObjects(objects, context: self)
        }
        */
    }
}
