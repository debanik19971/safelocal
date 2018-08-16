//
//  AppDelegate.swift
//  Anasthesia
//
//  Created by Debanik Purkayastha on 6/19/18.
//  Copyright © 2018 DT4. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let anestheticDataFileName = "anesthetics"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let anestheticFactory = AnestheticFactory(anestheticList: parseJsonFile(fileName: anestheticDataFileName, decodeType: [Anesthetic].self)!)
        
        
        let navController = UINavigationController(rootViewController: ViewController(anestheticFactory: anestheticFactory))
        window?.rootViewController = navController
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func parseJsonFile<T: Codable>(fileName: String, decodeType: T.Type) -> T? {
        var decodedJSON: T? = nil
        if let jsonString = readFile(fileName: fileName, fileType: "json") {
            let jsonData = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            decodedJSON = try! decoder.decode(decodeType, from: jsonData)
        } else {
            print("Error parsing anesthetic JSON data file")
        }   

        return decodedJSON     
    }
    
    func readFile(fileName: String, fileType: String) -> String? {
        var data: String? = nil
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            do {
                data = try String(contentsOfFile: path, encoding: .utf8)
            } catch {
                print(error)
            }
        }

        return data;
    }
}

