//
//  TradingTaskCell.swift
//  ToDoUIKitNoStoryboard
//
//  Created by Евгений Лукин on 06.07.2025.
//

import UIKit

// MARK: - TradingTaskCell
final class TradingTaskCell: UITableViewCell {
    static let identifier = "TradingTaskCell"

    private let taskLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(taskLabel)

        NSLayoutConstraint.activate([
            taskLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            taskLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with text: String, index: Int, status: TaskStatus) {
        let numberPrefix = "\(index + 1). "
        let cleaned = text.replacingOccurrences(of: #"^\d+\.\s"#, with: "", options: .regularExpression)
        let fullText = numberPrefix + cleaned

        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = 0
        paragraph.headIndent = (numberPrefix as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)]).width

        let attributed = NSMutableAttributedString(string: fullText)

        var attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraph,
            .font: UIFont.systemFont(ofSize: 17)
        ]

        switch status {
        case .completed:
            attributes[.foregroundColor] = UIColor.secondaryLabel
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        case .active:
            attributes[.foregroundColor] = UIColor.label
        }

        attributed.addAttributes(attributes, range: NSRange(location: 0, length: attributed.length))
        taskLabel.attributedText = attributed
    }
}
