//
//  SceneDelegate.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 30.06.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = ViewController() //Стартовый экран
        self.window = window
        window.makeKeyAndVisible()
    }
}


