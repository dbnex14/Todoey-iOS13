//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Print path to locate where realm db is stored if we need it
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // Create new item to our persistance Realm db container
        do {
            // Realm allows us to use OOP and persist objects.  We
            // leave this here just in order to catch any errors
            // if there are any when we attempt to initialize realm.
            //let realm = try Realm()
            // Since we are not using it, we make it underscore and
            // we remove let key
            _ = try Realm()
        } catch {
            print("Error initializing new Realm, \(error)")
        }
        
        return true
    }
}

