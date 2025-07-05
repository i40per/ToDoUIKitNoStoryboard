//
//  UserDefaults+Launch.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 05.07.2025.
//

import Foundation

extension UserDefaults {
    private static let firstLaunchKey = "hasBeenLaunchedBefore"

    static var isFirstLaunch: Bool {
        get {
            let hasLaunched = standard.bool(forKey: firstLaunchKey)
            return !hasLaunched
        }
        set {
            standard.set(!newValue, forKey: firstLaunchKey)
        }
    }
}
