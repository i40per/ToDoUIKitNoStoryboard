//
//  TaskModel.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 02.07.2025.
//

import Foundation

// MARK: - TaskModel
struct TaskModel: Codable {
    var title: String
    var isCompleted: Bool
}
