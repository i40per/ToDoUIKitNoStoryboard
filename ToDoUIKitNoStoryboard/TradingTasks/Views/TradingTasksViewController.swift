//
//  TradingTasksViewController.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 30.06.2025.
//

import UIKit

// MARK: - TradingTasksViewController
class TradingTasksViewController: UIViewController {
    
    // MARK: - Title Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trading Day Plan"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE, d MMMM"
        let date = formatter.string(from: Date()).capitalized
        label.text = date

        return label
    }()

    
    private func setupTitleView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2

        navigationItem.titleView = stackView
    }

    // MARK: - UI
    private let tradingTasksTableView = UITableView()
    private var lastTapInfo: (indexPath: IndexPath, time: Date)?

    // MARK: - Presenter
    private let presenter = TaskPresenter()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTitleView()
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
        tradingTasksTableView.dragDelegate = self
        tradingTasksTableView.dropDelegate = self
        tradingTasksTableView.dragInteractionEnabled = true
        tradingTasksTableView.rowHeight = UITableView.automaticDimension
        tradingTasksTableView.estimatedRowHeight = 60
        tradingTasksTableView.register(TradingTaskCell.self, forCellReuseIdentifier: TradingTaskCell.identifier)

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
                title: "Добро пожаловать 👋",
                message: """
                Это ваш список задач на трейдинг-день.

                Одинарный тап — редактировать задачу.
                Двойной тап — отметить как выполненную.
                Долгий тап — изменить порядок задач.
                """,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Поехали!", style: .default))
            present(alert, animated: true)
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
            guard let taskText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !taskText.isEmpty else { return }

            let cleanedText = taskText.replacingOccurrences(of: #"^\d+\.\s"#, with: "", options: .regularExpression)
            self?.presenter.addTask(with: cleanedText)
        }

        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    private func handleSingleTap(at indexPath: IndexPath) {
        let task = presenter.tasks[indexPath.row]

        let editVC = EditTaskViewController()
        editVC.configure(with: task.title)
        editVC.onSave = { [weak self] newText in
            self?.presenter.updateTask(at: indexPath.row, with: newText)
        }

        let navVC = UINavigationController(rootViewController: editVC)
        present(navVC, animated: true)
    }

    private func handleDoubleTap(at indexPath: IndexPath) {
        presenter.toggleTask(at: indexPath.row)
    }
}

// MARK: - UITableViewDataSource
extension TradingTasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TradingTaskCell.identifier,
            for: indexPath
        ) as? TradingTaskCell else {
            return UITableViewCell()
        }

        let task = presenter.tasks[indexPath.row]
        cell.configure(with: task.title, index: indexPath.row, status: task.status)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TradingTasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tapTime = Date()
        let currentTapInfo = (indexPath: indexPath, time: tapTime)

        if let last = lastTapInfo,
           last.indexPath == indexPath,
           tapTime.timeIntervalSince(last.time) < 0.4 {

            handleDoubleTap(at: indexPath)
            lastTapInfo = nil

        } else {
            lastTapInfo = currentTapInfo

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
                guard let self = self else { return }

                // ВАЖНО: используем сохранённый tapInfo
                if let last = self.lastTapInfo,
                   last.indexPath == currentTapInfo.indexPath,
                   last.time == currentTapInfo.time {

                    self.handleSingleTap(at: indexPath)
                    self.lastTapInfo = nil
                }
            }
        }

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

// MARK: - UITableViewDragDelegate & UITableViewDropDelegate
extension TradingTasksViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let task = presenter.tasks[indexPath.row]
        let itemProvider = NSItemProvider(object: task.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = indexPath
        return [dragItem]
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }

        coordinator.items.forEach { dropItem in
            if let sourceIndexPath = dropItem.dragItem.localObject as? IndexPath {
                presenter.moveTask(from: sourceIndexPath.row, to: destinationIndexPath.row)
                tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            }
        }
    }

    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

// MARK: - TaskPresenterDelegate
extension TradingTasksViewController: TaskPresenterDelegate {
    func taskDidChange(_ change: TaskChangeType) {
        switch change {
        case .added(let index):
            tradingTasksTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)

        case .removed, .reloaded:
            tradingTasksTableView.reloadData()

        case .updated(let index):
            tradingTasksTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)

        case .toggled(let index):
            let indexPath = IndexPath(row: index, section: 0)

            guard let cell = tradingTasksTableView.cellForRow(at: indexPath) as? TradingTaskCell else {
                tradingTasksTableView.reloadRows(at: [indexPath], with: .fade)
                return
            }

            let task = presenter.tasks[index]
            cell.animateCompletionChange(
                isCompleted: task.status == .completed,
                index: index,
                title: task.title
            )
        }

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
