//
//  TradingTaskCell.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 06.07.2025.
//

import UIKit

// MARK: - TradingTaskCell
final class TradingTaskCell: UITableViewCell {

    // MARK: - Identifier
    static let identifier = "TradingTaskCell"

    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    func configure(with title: String, index: Int, status: TaskStatus) {
        titleLabel.text = "\(index + 1). \(title)"

        switch status {
        case .active:
            titleLabel.textColor = .label
            titleLabel.attributedText = NSAttributedString(
                string: titleLabel.text ?? "",
                attributes: [.strikethroughStyle: 0]
            )
        case .completed:
            titleLabel.textColor = .secondaryLabel
            titleLabel.attributedText = NSAttributedString(
                string: titleLabel.text ?? "",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.secondaryLabel
                ]
            )
        }
    }

    // MARK: - Layout
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Animation
    func animateCompletionChange(isCompleted: Bool, index: Int, title: String) {
        let highlightAlpha: CGFloat = isCompleted ? 0.3 : 1.0

        configure(with: title, index: index, status: isCompleted ? .completed : .active)

        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.contentView.alpha = highlightAlpha
        } completion: { _ in
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

            UIView.animate(withDuration: 0.25) {
                self.contentView.alpha = 1.0
            }
        }
    }
}
