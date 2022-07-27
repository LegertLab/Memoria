//
//  SceneDelegate.swift
//  NewQuestionnaire
//
//  Created by Anastasia Legert on 06.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController()
        let vc = PersonListVC()
        navController.viewControllers = [vc]
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}

