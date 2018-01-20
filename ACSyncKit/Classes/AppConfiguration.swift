//
//  AppConfigurator.swift
//  PostSurgicalMonitoring
//
//  Created by Austin Chen on 2016-06-01.
//  Copyright © 2016 Hubub Health. All rights reserved.
//

import Foundation

public protocol AppConfiguratorType {
    var remoteSession: ACRemoteSession? {get set}
    var syncCoordinator: ACSyncCoordinator? {get set}
    func configure() -> AppConfiguration?
}

public struct AppConfigurator: AppConfiguratorType {
    // builder properties
    public var remoteSession: ACRemoteSession?
    public var syncCoordinator: ACSyncCoordinator?
    
    public func configure() -> AppConfiguration? {
        guard let rs = self.remoteSession else {
            fatalError("AppConfigurator - configure error")
        }
        let configuration = AppConfiguration()
        
        // set up configration here
        
        return configuration
    }
}


let kAppConfigurationRemoteSession = "remoteSession"
let kAppConfigurationSyncCoordinator = "syncCoordinator"

public typealias AppConfiguration = NSMutableDictionary // subclass dictionary would require override methods

extension AppConfiguration {
    
    open var isValid: Bool {
        get {
            if let _ = self[kAppConfigurationRemoteSession] as? ACRemoteSession,
                let _ = self[kAppConfigurationSyncCoordinator] as? ACSyncCoordinator
            {
                return true
            } else {
                return false
            }
        }
    }
    
    open static func appVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    open static func appBuild() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    open static func versionWithBuild() -> String {
        return String(format: "%@ (%@)", self.appVersion(), self.appBuild())
    }
}

