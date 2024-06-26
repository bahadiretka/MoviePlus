//
//  UIView+.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 25.06.2024.
//

import Foundation
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
