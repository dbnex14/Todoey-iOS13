//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // CALLED WHEN APP IS LOADED UP, SO FIRST THING EVEN BEFORE VIEWDIDLOAD INSIDE A VIEW CONTROLLER
        //print("didFinishLaunchingWithOptions")
        
        // TO PRINT THE FILE PATH OF OUR SANDBOX WHERE OUR APP RUNS.  TO DO SO MAKE SURE YOU RUN
        // SIMULATOR AND NOT A PHISICAL DEVICE AND THAT YOU ADDED A NEW ITEM TO OUR TABLEVIEW.
        // THIS WILL PRINT SOMETHING LIKE:
        // "/Users/dinob/Library/Developer/CoreSimulator/Devices/"
        // "B4B09863-4003-4FB0-8A9F-7DE877BD347D/data/Containers/Data/Application/"
        // "88C6D8E8-CF3D-4DF3-BDB0-30C73963D2C6/Documents".  INSTEAD OF GOING TO DOCUMENTS AT THE END
        // OF THIS PATH, GO TO LIBRARY/PREFERENCES AND ASSUMING YOU ADDED A NEW ITEM TO THE TABLEVIEW,
        // YOU SHOULD SEE IN THERE THE FILE NAMED LIKE com.dino.todoey-ios13.Todoey.plist AND IF YOU
        // OPEN IT BY DOUBLE CLICKING IT, IT OPENS INSIDE XCODE AND YOU WILL SEE KEY "TodoListArray" and
        // INSIDE IT ITEMS CONTAINED IN itemArray to which we also added an item
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        // IF SOMETHING HAPPENS WHILE APP IS OPEN, I.E. USER RECEIVES PHONE CALL WHILE YOU WERE
        // FILLING IN A FORM.  SO HERE YOU SAVE DATA BEFORE BEING INTERRUPTED BY ANOTHER APP
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // HAPPENS WHEN APP DISAPEARS OFF THE SCREEN I.E. USER PRESSES HOME BUTTON OR OPENS ANOTHER APP
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // called if app is about to be terminates.  Save data if appropriate.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
           /*
            The persistent container for the application. This implementation
            creates and returns a container, having loaded the store for the
            application to it. This property is optional since there are legitimate
            error conditions that could cause the creation of the store to fail.
           */
           let container = NSPersistentContainer(name: "DataModel")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                   /*
                    Typical reasons for an error here include:
                    * The parent directory does not exist, cannot be created, or disallows writing.
                    * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                    * The device is out of space.
                    * The store could not be migrated to the current model version.
                    Check the error message to determine what the actual problem was.
                    */
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()

       // MARK: - Core Data Saving support

       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }

}

