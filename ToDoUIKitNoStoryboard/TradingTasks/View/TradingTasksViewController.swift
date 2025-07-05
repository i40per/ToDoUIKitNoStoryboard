//
//  TradingTasksViewController.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 30.06.2025.
//

import UIKit

// MARK: - TradingTasksViewController
class TradingTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    private let tradingTasksTableView = UITableView()

    // MARK: - Presenter
    private let presenter = TaskPresenter()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trading Day Plan"
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTradingTasksTableView()
        showFirstLaunchAlertIfNeeded()
        presenter.delegate = self
    }

    // MARK: - Setup UI
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTaskButtonTapped)
        )
    }

    private func setupTradingTasksTableView() {
        view.addSubview(tradingTasksTableView)
        tradingTasksTableView.translatesAutoresizingMaskIntoConstraints = false
        tradingTasksTableView.delegate = self
        tradingTasksTableView.dataSource = self
        tradingTasksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TradingTaskCell")

        NSLayoutConstraint.activate([
            tradingTasksTableView.topAnchor.constraint(equalTo: view.topAnchor),
            tradingTasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tradingTasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tradingTasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Alerts
    private func showFirstLaunchAlertIfNeeded() {
        if UserDefaults.isFirstLaunch {
            let alert = UIAlertController(
                title: "Добро пожаловать!",
                message: "Это первый запуск приложения. Добавьте свои задачи на день, чтобы начать.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
            //Сбрасываю флаг
            UserDefaults.isFirstLaunch = false
        }
    }

    // MARK: - Actions
    @objc private func addTaskButtonTapped() {
        let alert = UIAlertController(title: "Новая задача", message: "Введите текст задачи", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Например, «Проверить рынок»"
        }

        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let taskText = alert.textFields?.first?.text, !taskText.isEmpty else { return }
            self?.presenter.addTask(with: taskText)
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TradingTaskCell", for: indexPath)
        let task = presenter.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.toggleTask(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeTask(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, completionHandler) in
            self?.presenter.removeTask(at: indexPath.row)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - TaskPresenterDelegate
extension TradingTasksViewController: TaskPresenterDelegate {
    func tasksDidUpdate() {
        tradingTasksTableView.reloadData()
        
        if presenter.tasks.isEmpty && !UserDefaults.isFirstLaunch {
            let alert = UIAlertController(
                title: "Нет задач",
                message: "У вас пока нет задач. Нажмите +, чтобы добавить первую.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
