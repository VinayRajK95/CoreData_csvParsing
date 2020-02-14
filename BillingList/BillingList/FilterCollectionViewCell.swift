//
//  FilterCollectionViewCell.swift
//  BillingList
//
//  Created by Vinay on 11/07/19.
//  Copyright © 2019 Vinay. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "filterCell"
    
    fileprivate var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        titleLabel.lineBreakMode = .byWordWrapping
        return titleLabel
    }()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.masksToBounds = true
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    func toggleButtonSelection(_ shouldSelect: Bool) {
        self.contentView.layer.borderColor = shouldSelect ? UIColor.kLightBlue.cgColor : UIColor.lightGray.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toggleButtonSelection(false)
        self.title = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
