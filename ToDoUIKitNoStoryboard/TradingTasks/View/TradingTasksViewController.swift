//
//  TradingTasksViewController.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 30.06.2025.
//

import UIKit

//MARK: - TradingTasksViewController
class TradingTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UI Elements
    private let tradingTasksTableView = UITableView()
    
    // MARK: - Presenter
    private let presenter = TaskPresenter()
    
    //MARK: - Data
    private let TradingTasks = [
        "06:30 — Проснуться, выпить кофе",
        "07:00 — Пройтись по утреннему обзору рынка",
        "09:00 — Открытие Европы: мониторинг EUR/USD",
        "12:00 — Разбор новостей на ForexFactory",
        "16:30 — Волатильность NYSE: анализ S&P 500",
        "20:00 — Подведение итогов, запись в журнал"
    ]
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trading Day Plan"
        view.backgroundColor = .systemBackground
        setupTradingTasksTableView()
        presenter.delegate = self
    }
    
    //MARK: - Setup
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
    
    //MARK: - UITableViewDataSource
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
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.toggleTask(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Presenter
extension TradingTasksViewController: TaskPresenterDelegate {
    func tasksDidUpdate() {
        tradingTasksTableView.reloadData()
    }
}
