//
//  Constant.swift
//  RandomFace
//
//  Created by TrungNV on 10/17/19.
//  Copyright © 2019 TrungNV. All rights reserved.
//

import Foundation
import UIKit

class Constant{
    static func saveImage(image: UIImage,name: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(name).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    // to use
    // let success = saveImage(image: UIImage(named: "image.png")!)
    
    static func getSavedImage(named: String) -> UIImage {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path) ?? UIImage()
        }
        return UIImage()
    }
    
    /*
     To use
     if let image = getSavedImage(named: "fileName") {
     // do something with image
     }
     **/
    
    static func saveLstPerson(_ lst: [PersonBO]){
        var lstString = [String]()
        for item in lst{
            let str = "\(item.timeTamp)__\(item.name)"
            lstString.append(str)
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(lstString, forKey: "persons")
        userDefaults.synchronize()
   
    }
    
    static func getLstPerson() -> [PersonBO]{
        let userDefaults = UserDefaults.standard
        let savedArray = userDefaults.object(forKey: "persons") as? [String] ?? [String]()
        var lstPerson = [PersonBO]()
        for item in savedArray{
            var name = ""
            var timeTamp = ""
            let lstInfo: [String] = item.split("__")
            if lstInfo.count > 1{
                name =  lstInfo[1]
            }
            if lstInfo.count > 0{
                timeTamp = lstInfo[0]
            }
            let person = PersonBO(name: name, timeTamp: timeTamp, image: Constant.getSavedImage(named: timeTamp))
            lstPerson.append(person)
        }
        return lstPerson
    }
    
    static func resize(image: UIImage, maxHeight: Float = 200, maxWidth: Float = 200) -> UIImage? {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in:rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    /*
      let newImage = resize(image: image, maxHeight: 600, maxWidth: 600) ?? UIImage()
     **/
}
