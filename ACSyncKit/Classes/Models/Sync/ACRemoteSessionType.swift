//
//  ACRemoteSessionType.swift
//  ACSyncKit
//
//  Created by achen2 on 2019-05-02.
//

import Foundation

public protocol ACRemoteSessionType {
    var postAuthenticationHttpHeaders: [String: String] {get}
    var domain: String {get}
}
