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
        return TradingTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TradingTaskCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = TradingTasks[indexPath.row]
        config.textProperties.font = .systemFont(ofSize: 16, weight: .medium)
        config.textProperties.color = .label
        cell.contentConfiguration = config
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
