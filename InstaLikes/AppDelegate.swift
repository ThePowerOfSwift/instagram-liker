//
//  AppDelegate.swift
//  InstaLikes
//
//  Created by Taras Markevych on 4/4/17.
//  Copyright © 2017 ITChallenge. All rights reserved.
//

import UIKit
import SafariServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        InstagramApi.shared.registration()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
                print("app: \(app)")
                print("url: \(url)")
                print("options: \(options)")
        
        if let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] {
            
            if (String(describing: sourceApplication) == "com.apple.SafariViewService") {
                NotificationCenter.default.post(name: Notification.Name(rawValue: kSafariViewControllerCloseNotification), object: url)
                return true
            }
        }
        
        return true
    }


}

