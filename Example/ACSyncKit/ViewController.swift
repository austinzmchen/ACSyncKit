//
//  ViewController.swift
//  ACSyncKit
//
//  Created by austinzmchen on 01/19/2018.
//  Copyright (c) 2018 austinzmchen. All rights reserved.
//

import UIKit
import ACSyncKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // sample call
        let syncer = ACSyncCoordinator(remoteSession: ACRemoteSession(domain: "tmpDomain"))
        syncer.syncAll { (success, results, error) in
            print(success)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

