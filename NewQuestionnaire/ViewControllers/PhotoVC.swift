//
//  PhotoVC.swift
//  Memoria
//
//  Created by Anastasia Legert on 20.05.2022.
//

import UIKit

class PhotoVC: UIViewController {
    
    let addPhotoButton = { () -> UIButton in
        let button = UIButton()
        button.setTitle("Добавить фото", for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    
    let imageView = UIImageView()
    
    var contentObject: ContentForQuestion!
    var contentImageUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(contentImageUrl)
        setupButton()
        setupImageView()
    }
    
    func setupActionAlertController () {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let cameraIcon = UIImage(systemName: "camera")
        let photoIcon = UIImage(systemName: "photo")
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePeaker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePeaker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true)
        
    }
    func setupButton() {
        view.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 24, bottom: 0, right: 24))
    }
    func setupImageView () {
        view.addSubview(imageView)
        imageView.anchor(top: addPhotoButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24))
        imageView.constrainHeight(constant: 350)
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        imageView.layer.cornerRadius = 10
        
        if contentObject.images != "" {
            let imageURL = URL(fileURLWithPath: contentImageUrl)
            if let image = UIImage(contentsOfFile: imageURL.path) {
                imageView.image = image
            } else {
                imageView.image = UIImage(named: "mom")
            }
        }
        //let data = FileManager.default.contents(atPath: contentImageUrl)
        //print(data)
        
        //            guard let unwrappedData = data else {
        //                imageView.image = UIImage(named: "mom")//(contentsOfFile: "file:///Users/legert/Library/Developer/CoreSimulator/Devices/6342767A-1BAA-40E0-956E-098BE8753B13/data/Containers/Data/Application/A2A2EDCF-9904-4983-9FBD-195F5D22CB67/Documents/282EE97B-11C8-452E-9CA5-312EBA1AABCD.png") //(contentsOfFile: contentImageUrl) //(named: "mom")
        //                return
        //            }
        //            let image = UIImage(data: unwrappedData)
        //            imageView.image = image
        
    }
    
    @objc fileprivate func addPhoto () {
        setupActionAlertController()
    }
}

// MARK: Work with image
extension PhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePeaker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePeaker = UIImagePickerController()
            imagePeaker.delegate = self
            imagePeaker.allowsEditing = true
            imagePeaker.sourceType = source
            self.present(imagePeaker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.editedImage] as? UIImage
        let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:
                                                        FileManager.SearchPathDomainMask.userDomainMask).first
        
        let imageFileName = UUID().uuidString + ".png"
        let imageFileURL = directoryURL!.appendingPathComponent(imageFileName)
        contentImageUrl = imageFileURL.path
        try! RealmManager.shared.localRealm.write {
            contentObject.images = contentImageUrl
        }
        if let data = imageView.image?.pngData() {
            try? data.write(to: imageFileURL, options: .atomic)
        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addPhotoButton.setTitle("Изменить фото", for: .normal)
        self.dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
