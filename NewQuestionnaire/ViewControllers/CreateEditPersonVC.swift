//
//  CreateChangePersonVC.swift
//  Memoria
//
//  Created by Anastasia Legert on 18.05.2022.
//

import UIKit

class CreateEditPersonVC: UIViewController {
    
    var person = Person()
    var personImageUrl = ""
    var personImageView = { () -> UIImageView in
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 1
        image.clipsToBounds = true
        return image
    }()
    
    var chooseAvatarButton = { () -> UIButton in
        let button = UIButton()
        button.setTitle("Добавить фото", for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    var personNameTextField = { () -> UITextField in
        let textfield = UITextField()
        textfield.layer.cornerRadius = 8
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.gray.cgColor
        textfield.textAlignment = .center
        return textfield
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if person.name.isEmpty {
            navigationItem.title = "Добавить персону"
            personNameTextField.placeholder = "Введите имя персоны"
        } else {
            navigationItem.title = "Изменить персону"
            chooseAvatarButton.setTitle("Изменить фото", for: .normal)
            personNameTextField.text = person.name
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePerson))
        
        if let personImage = person.image  {
            personImageView.image = UIImage(named: personImage)
        } else {
            personImageView.image = UIImage(named: "noImage")
        }
        
        setupLayout()
    }
    
    func setupLayout () {
        
        view.addSubview(personNameTextField)
        view.addSubview(personImageView)
        view.addSubview(chooseAvatarButton)
        
        personNameTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 30))
        
        personImageView.anchor(top: personNameTextField.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 200, height: 200))
        personImageView.centerXInSuperview()
        
        chooseAvatarButton.anchor(top: personImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 30))
        
        
        
    }
    
    @objc func savePerson() {
        if RealmManager.shared.personExists(person) {
            try! RealmManager.shared.localRealm.write {
                person.name = personNameTextField.text!
            }
        } else {
            person.name = personNameTextField.text!
            RealmManager.shared.savePerson(person: person)
        }
        
        navigationController?.popViewController(animated: true)
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
    
    @objc fileprivate func addPhoto () {
        setupActionAlertController()
    }
    
}

// MARK: Work with image
extension CreateEditPersonVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        
        personImageView.image = info[.editedImage] as? UIImage
        let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:
                                                        FileManager.SearchPathDomainMask.userDomainMask).first // as! NSURL
        
        let imageFileName = UUID().uuidString + ".png"
        let imageFileURL = directoryURL!.appendingPathComponent(imageFileName)
        personImageUrl = imageFileURL.path
        try! RealmManager.shared.localRealm.write {
            person.image = personImageUrl
        }
        if let data = personImageView.image?.pngData() {
            try? data.write(to: imageFileURL, options: .atomic)
        }
        
        personImageView.contentMode = .scaleAspectFill
        personImageView.clipsToBounds = true
        chooseAvatarButton.setTitle("Изменить фото", for: .normal)
        self.dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
