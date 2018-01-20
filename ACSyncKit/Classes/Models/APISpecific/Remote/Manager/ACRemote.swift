//
//  ACRemote.swift
//  <?>App
//
//  Created by Austin Chen on 2016-04-26.
//

import Foundation
import CoreData

public protocol ACRemoteRecordSyncableType {
    var id: String { get }
}

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
}

import Alamofire

/* remote settings
 */
public struct ACRemoteSettings {
    public static let serialQueue: DispatchQueue = DispatchQueue(label: "com.ac.snackabletv.remote-serial-queue", attributes: [])
    public static let concurrentQueue: DispatchQueue = DispatchQueue(label: "com.ac.snackabletv.remote-concurrent-queue", attributes: DispatchQueue.Attributes.concurrent)
}

/// All Remote subclasses fetch remote data ASYNCHRONOUSLY, so be aware the completion block is NOT executed on main thread

open class ACSimpleRemote: NSObject {
    // api version
    open let apiVersion = "1.0.0"
    
    // domains
    open let domain: String
    
    // base urls
    open var baseUrl: String
    static var stBaseUrl: String {
        return ""
    }
    
    open var alamoFireManager: SessionManager = ACSessionManager.shared
    
    override init() {
        domain = "localhost"
        baseUrl = "https://" + domain
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            domain: .disableEvaluation
        ]
        alamoFireManager = SessionManager(configuration: URLSessionConfiguration.default,
                                          serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        
        super.init()
    }
}

open class ACRemote: ACSimpleRemote {
    open let isRetryEnabled = false
    open let remoteSession: ACRemoteSessionType?
    
    public init(remoteSession: ACRemoteSession?) {
        self.remoteSession = remoteSession
        
        super.init()
        
//        if let d = self.remoteSession?.domain {
            baseUrl = "http://52.60.183.54:8080"
//        }
        
        if isRetryEnabled,
            let rs = self.remoteSession
        {
            // configure adapter and retry
            /*let retryHandler = ACRemoteRetryHandler(domain: rs.domain, accessToken: rs.accessToken)
            alamoFireManager.adapter = retryHandler
            alamoFireManager.retrier = retryHandler*/ // Todo
        } else {
            print("error: ACRemoteRetryHandler not configured")
        }
    }
}

// for AlamoFire 4.0 + 

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

