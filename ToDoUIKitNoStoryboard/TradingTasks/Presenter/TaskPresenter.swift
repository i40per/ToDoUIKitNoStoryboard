//
//  TaskPresenter.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 02.07.2025.
//

import Foundation

// MARK: - TaskPresenterDelegate
protocol TaskPresenterDelegate: AnyObject {
    func tasksDidUpdate()
}

// MARK: - TaskPresenter
final class TaskPresenter {

    // MARK: - Properties
    weak var delegate: TaskPresenterDelegate?
    private(set) var tasks: [TaskModel] = []
    private let tasksKey = "savedTasks"

    init() {
        loadTasks()
    }

    // MARK: - Task Management
    func toggleTask(at index: Int) {
        tasks[index].isCompleted.toggle()
        saveTasks()
        delegate?.tasksDidUpdate()
    }

    func addTask(with title: String) {
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let newTask = TaskModel(title: cleanedTitle, isCompleted: false)
        tasks.append(newTask)
        saveTasks()
        delegate?.tasksDidUpdate()
    }

    func removeTask(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks.remove(at: index)
        saveTasks()
        delegate?.tasksDidUpdate()
    }

    func updateTask(at index: Int, with newTitle: String) {
        guard tasks.indices.contains(index) else { return }
        let cleanedTitle = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        tasks[index].title = cleanedTitle
        saveTasks()
        delegate?.tasksDidUpdate()
    }

    // MARK: - Persistence
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
