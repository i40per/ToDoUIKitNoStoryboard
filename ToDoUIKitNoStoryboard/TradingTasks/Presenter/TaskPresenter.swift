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

    private(set) var tasks: [TaskModel] = [
        TaskModel(title: "Проверить экономический календарь", isCompleted: false),
        TaskModel(title: "Проанализировать утренний тренд", isCompleted: true),
        TaskModel(title: "Поставить лимитки на Лондон", isCompleted: false)
    ]
    
    // MARK: - Logic
    func toggleTask(at index: Int) {
        tasks[index].isCompleted.toggle()
        delegate?.tasksDidUpdate()
    }
    
    func addTask(with title: String) {
        let newTask = TaskModel(title: title, isCompleted: false)
        tasks.append(newTask)
        delegate?.tasksDidUpdate() // чтобы view обновилась
    }
    
    func removeTask(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks.remove(at: index)
        delegate?.tasksDidUpdate()
    }
}
