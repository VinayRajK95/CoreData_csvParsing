//
//  TableHeaderView.swift
//  BillingList
//
//  Created by Vinay on 11/07/19.
//  Copyright © 2019 Vinay. All rights reserved.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    static let identifier = "CustomHeaderReuseIdentifier"
    let pinCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.darkGray
        return label
    }()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.kLightGray
        self.contentView.addSubview(pinCodeLabel)
        self.contentView.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            pinCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            pinCodeLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: 10),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            pinCodeLabel.heightAnchor.constraint(equalTo: amountLabel.heightAnchor),
            pinCodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            pinCodeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
    }
    
    func configure(pincodeText: String, amountText: String) {
        pinCodeLabel.text = pincodeText
        amountLabel.text = amountText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
