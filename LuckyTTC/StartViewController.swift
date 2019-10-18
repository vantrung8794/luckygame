//
//  StartViewController.swift
//  RandomFace
//
//  Created by TrungNV on 10/17/19.
//  Copyright © 2019 TrungNV. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnTakePicture: UIButton!
    
    var imagePicker: UIImagePickerController!
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI(){
        btnPlay.setRadius(8.0)
        btnTakePicture.setRadius(8.0)
    }
    
    //Mark: - Actions
    
    @IBAction func clearAllData(_ sender: Any) {
        // show alert to enter the name of guess
        TAlertView(alertTitle: "TTC Solutions", sub: nil, alertMainText: "Xác nhận xoá Data?", haveCancel: true, didAccept: { name in
            if name.uppercased() == "TTC"{
                  Constant.saveLstPerson([PersonBO]())
            }
        }, didCancel: nil).show()
      
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                print("Image not found!")
                return
            }
            // show alert to enter the name of guess
            TAlertView(alertTitle: "TTC Solutions", sub: nil, alertMainText: "Mời nhập tên vào ô bên dưới", haveCancel: true, didAccept: { name in
                
                var guessName = "Khách mời"
                if name != ""{
                    guessName = name
                }
                // Save Image
                var lstPerson = Constant.getLstPerson()
                let timeTamp: String = "\(Date.currentTimeStamp)"
                lstPerson.append(PersonBO(name: guessName, timeTamp: timeTamp , image: selectedImage))
                let saveImage = Constant.resize(image: selectedImage, maxHeight: 600, maxWidth: 600) ?? UIImage()
                _ = Constant.saveImage(image: saveImage, name: timeTamp)
                Constant.saveLstPerson(lstPerson)
            }, didCancel: nil).show()
        }
    }
    
    // save lst Person
}
