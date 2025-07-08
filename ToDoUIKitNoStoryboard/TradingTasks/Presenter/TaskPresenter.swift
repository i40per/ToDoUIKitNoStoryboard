//
//  TaskPresenter.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 02.07.2025.
//

import Foundation

// MARK: - Task Change Type
enum TaskChangeType {
    case added(index: Int)
    case removed(index: Int)
    case updated(index: Int)
    case toggled(index: Int)
    case reloaded
}

// MARK: - TaskPresenterDelegate
protocol TaskPresenterDelegate: AnyObject {
    func taskDidChange(_ change: TaskChangeType)
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
        let task = tasks[index]

        tasks[index].status = (task.status == .completed) ? .active : .completed

        saveTasks()
        delegate?.taskDidChange(.toggled(index: index))
    }

    func addTask(with title: String) {
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let newTask = TaskModel(title: cleanedTitle, status: .active)
        tasks.append(newTask)
        saveTasks()
        delegate?.taskDidChange(.added(index: tasks.count - 1))
    }

    func removeTask(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks.remove(at: index)
        saveTasks()
        delegate?.taskDidChange(.removed(index: index))
    }

    func updateTask(at index: Int, with newTitle: String) {
        guard tasks.indices.contains(index) else { return }
        let cleanedTitle = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleanedTitle != tasks[index].title else { return }
        tasks[index].title = cleanedTitle
        saveTasks()
        delegate?.taskDidChange(.updated(index: index))
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
