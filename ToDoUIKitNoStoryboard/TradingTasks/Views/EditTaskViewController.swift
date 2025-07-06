//
//  EditTaskViewController.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 06.07.2025.
//

import UIKit

// MARK: - EditTaskViewController
final class EditTaskViewController: UIViewController {

    // MARK: - Public Properties
    var onSave: ((String) -> Void)?

    // MARK: - UI
    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.cornerRadius = 8
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.borderWidth = 1
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textContainerInset.top = 0
        return tv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Редактировать задачу"
        
        setupNavigationBar()
        setupLayout()
    }
    
    // MARK: - View Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
        moveCursorToEnd()
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
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }

    private func setupLayout() {
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Public Methods
    func configure(with text: String) {
        textView.text = text
    }
    
    // MARK: - Private Methods
    private func moveCursorToEnd() {
        let endPosition = textView.endOfDocument
        textView.selectedTextRange = textView.textRange(from: endPosition, to: endPosition)
    }

    // MARK: - Actions
    @objc private func saveButtonTapped() {
        let trimmed = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleaned = trimmed.replacingOccurrences(of: #"^\d+\.\s"#, with: "", options: .regularExpression)
        guard !cleaned.isEmpty else { return }
        onSave?(cleaned)
        dismiss(animated: true)
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
