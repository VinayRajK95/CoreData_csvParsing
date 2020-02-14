//
//  UIKit+Extensions.swift
//  BillingList
//
//  Created by Vinay on 11/07/19.
//  Copyright © 2019 Vinay. All rights reserved.
//

import UIKit

extension UIColor {
    static var kLightGray: UIColor {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    }
    static var kLightBlue: UIColor {
        return UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    }
}

extension NSLayoutConstraint {
    static func constraints(with formats: [String], views: [String: UIView], and metrics: [String : Any]? = nil) -> [NSLayoutConstraint] {
        var constraintsArray = [NSLayoutConstraint]()
        for format in formats {
            constraintsArray += constraints(withVisualFormat: format,
                                                          options: .init(rawValue: 0),
                                                          metrics: metrics,
                                                          views: views)
        }
        return constraintsArray
    }
}
