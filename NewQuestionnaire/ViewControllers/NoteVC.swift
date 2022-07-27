//
//  NoteTextView.swift
//  Memoria
//
//  Created by Anastasia Legert on 20.05.2022.
//

import UIKit

class NoteVC: UIViewController {
    
    var noteTextView = UITextView()
    let editTextButton = { () -> UIButton in
        let button = UIButton()
        button.setTitle("Редактировать заметку", for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(editText), for: .touchUpInside)
        return button
    }()
    
    var contentObject: ContentForQuestion!
    var contentText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(editTextButton)
        view.addSubview(noteTextView)
        
        setupButton()
        setupTextView()
        
    }
    
    func setupTextView() {
        if let contentText = contentText {
            noteTextView.text = contentText
        } else {
            noteTextView.text = "Запишите воспоминание"
        }
        noteTextView.font = UIFont.systemFont(ofSize: 17)
        noteTextView.backgroundColor = .white
        noteTextView.layer.cornerRadius = 10
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        noteTextView.isEditable = false
        
        noteTextView.anchor(top: editTextButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24), size: CGSize(width: (Int(view.bounds.width) - 50), height: Int(view.bounds.height) / 3))
        
    }
    
    func setupButton() {
        editTextButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 24, bottom: 0, right: 24))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        noteTextView.resignFirstResponder()
    }
    
    @objc func updateTextView (notification: Notification) {
        let userInfo = notification.userInfo
        
        let getKeyboardRect = (userInfo![NoteVC.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrame = view.convert(getKeyboardRect, to: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = UIEdgeInsets.zero
        } else {
            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height / 4, right: 0)
            noteTextView.scrollIndicatorInsets = noteTextView.contentInset
        }
    }
    
    @objc fileprivate func editText () {
        if noteTextView.isEditable == false {
            noteTextView.isEditable = true
            noteTextView.becomeFirstResponder()
            editTextButton.setTitle("Завершить редактирование", for: .normal)
        } else {
            noteTextView.isEditable = false
            try! RealmManager.shared.localRealm.write {
                contentObject.text = noteTextView.text!
            }
            noteTextView.resignFirstResponder()
            editTextButton.setTitle("Редактировать заметку", for: .normal)
        }
    }
}

