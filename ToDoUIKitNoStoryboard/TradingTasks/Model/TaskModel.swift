//
//  TaskModel.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 02.07.2025.
//

import Foundation

// MARK: - TaskStatus
enum TaskStatus: String, Codable {
    case active
    case completed
}

// MARK: - TaskModel
struct TaskModel: Codable {
    var title: String
    var status: TaskStatus
}
