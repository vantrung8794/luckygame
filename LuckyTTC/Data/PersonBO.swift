//
//  PersonBO.swift
//  RandomFace
//
//  Created by TrungNV on 10/16/19.
//  Copyright © 2019 TrungNV. All rights reserved.
//

import Foundation
import UIKit

class PersonBO: NSObject {
    var name: String
    var timeTamp: String
    var image: UIImage
    
    init(name: String, timeTamp: String, image: UIImage) {
        self.name = name
        self.timeTamp = timeTamp
        self.image = image
    }
    
    func clone() -> PersonBO{
        return PersonBO(name: self.name, timeTamp: self.timeTamp, image: self.image)
    }
}
