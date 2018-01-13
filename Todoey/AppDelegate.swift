//
//  AppDelegate.swift
//  Todoey
//
//  Created by Curtis Colly on 1/9/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
    
        do{
        _ = try Realm() // using the _ because we're not using this realm
           
        } catch {
            print("Error initialiazing new realm, \(error)")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }


  


}

