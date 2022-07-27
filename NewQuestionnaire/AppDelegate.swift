//
//  AppDelegate.swift
//  Memoria
//
//  Created by Anastasia Legert on 06.05.2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(
          // Set the new schema version. This must be greater than the previously used
          // version (if you've never set a schema version before, the version is 0).
          schemaVersion: 1,
          migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: Person.className()) { (_, newPerson) in
                       newPerson?["id"] = ""
                   }
            }
          })
        Realm.Configuration.defaultConfiguration = config
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func applicationDidFinishLaunching(_ aNotification: Notification) {
    }
        
}

