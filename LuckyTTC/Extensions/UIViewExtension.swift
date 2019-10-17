//
//  UIViewExtension.swift
//  RandomFace
//
//  Created by TrungNV on 10/15/19.
//  Copyright © 2019 TrungNV. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func setRadius(_ radius: CGFloat = 5.0) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    
    func createShadow(scale: Bool = true, color shadowColor: UIColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 4
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension String{
    func trim() -> String {
          return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      }
    
    func split(_ delimiter: String) -> [String] {
           return self.components(separatedBy: delimiter)
       }
}

extension Optional where Wrapped == String {
    func value(_ defaultValue: String = "") -> String {
        return self ?? defaultValue
    }
}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
