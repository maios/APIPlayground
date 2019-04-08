//
//  AppDelegate.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/6/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()

        let appNavigator = AppNavigator()
        window.rootViewController = appNavigator.navigationController

        self.window = window
        
        return true
    }
}

