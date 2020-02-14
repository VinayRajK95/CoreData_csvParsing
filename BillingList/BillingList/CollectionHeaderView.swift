//
//  CollectionHeaderView.swift
//  BillingList
//
//  Created by Vinay on 11/07/19.
//  Copyright © 2019 Vinay. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    static let identifier: String = "headerView"
    
    fileprivate var headerLabel: UILabel = {
        let headerLabel = UILabel(frame: .zero)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.numberOfLines = 1
        headerLabel.textColor = UIColor.darkGray
        headerLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        return headerLabel
    }()
    
    var title: String? {
        didSet {
            headerLabel.text = title?.uppercased()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            headerLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 8),
            headerLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -8)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
