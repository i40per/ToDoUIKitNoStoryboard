//
//  SceneDelegate.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 30.06.2025.
//

import UIKit

//MARK: - SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    //MARK: - Properties
    var window: UIWindow?
    
    //MARK: - UISceneDelegate
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: TradingTasksViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
