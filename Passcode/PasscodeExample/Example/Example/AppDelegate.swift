//
//  AppDelegate.swift
//  Example
//
//  Created by David Walter on 02.02.18.
//  Copyright © 2018 David Walter. All rights reserved.
//

import UIKit
import Passcode

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var code = "1234"
    
    lazy var passcode: Passcode = {
        let config = PasscodeConfig(passcodeGetter: {
            return self.code
        }, passcodeSetter: { code in
            self.code = code
        }, biometricsGetter: {
            return true
        })
        
        let passcode = Passcode(window: self.window, config: config)
        
        return passcode
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.passcode.authenticateWindow()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.passcode.authenticateWindow()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}

