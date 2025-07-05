//
//  TaskPresenter.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 02.07.2025.
//

import Foundation

// MARK: - Protocol
protocol TaskPresenterDelegate: AnyObject {
    func tasksDidUpdate()
}

// MARK: - TaskPresenter
final class TaskPresenter {
    
    // MARK: - Properties
    weak var delegate: TaskPresenterDelegate?
    
    private(set) var tasks: [TaskModel] = []
    
    init() {
        loadTasks()
    }
    
    // MARK: - Logic
    func toggleTask(at index: Int) {
        tasks[index].isCompleted.toggle()
        saveTasks()
        delegate?.tasksDidUpdate()
    }
    
    func addTask(with title: String) {
        let newTask = TaskModel(title: title, isCompleted: false)
        tasks.append(newTask)
        saveTasks()
        delegate?.tasksDidUpdate() // чтобы view обновилась
    }
    
    func removeTask(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks.remove(at: index)
        saveTasks()
        delegate?.tasksDidUpdate()
    }
    
    // MARK: - Persistence
    private let tasksKey = "savedTasks"
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([TaskModel].self, from: data) {
            tasks = decoded
        }
    }
}
