//
//  Colors.swift
//  Book_Sources
//
//  Created by Tim on 3/17/19.
//

import Foundation
import UIKit

// MARK: - UIColor
extension UIColor {
    static var userPink: UIColor {
        return UIColor(red: 208/255, green: 63/255, blue: 157/255, alpha: 1)
    }
    
    static var userGreen: UIColor {
        return UIColor(red: 80/255, green: 158/255, blue: 158/255, alpha: 1)
    }
    
    static var userRed: UIColor {
        return UIColor(red: 204/255, green: 72/255, blue: 67/255, alpha: 1)
    }
    
    static var userOrange: UIColor {
        return UIColor(red: 225/255, green: 150/255, blue: 2/255, alpha: 1)
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

// MARK: - Array
extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
