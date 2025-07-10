//
//  EditTaskViewController.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 06.07.2025.
//

import UIKit

// MARK: - EditTaskViewController
final class EditTaskViewController: UIViewController {

    // MARK: - Properties
    var onSave: ((String) -> Void)?
    private var originalText: String?

    // MARK: - UI
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Измените текст задачи"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Редактирование"
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupLayout()
        textField.becomeFirstResponder()
    }

    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }

    private func setupLayout() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Configure
    func configure(with text: String) {
        originalText = text
        textField.text = text
    }

    // MARK: - Actions
    @objc private func saveButtonTapped() {
        guard let newText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !newText.isEmpty,
              newText != originalText else {
            dismiss(animated: true)
            return
        }

        onSave?(newText)
        dismiss(animated: true)
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
