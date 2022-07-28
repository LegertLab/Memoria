//
//  CreateEditQuestionVC.swift
//  Memoria
//
//  Created by Anastasia Legert on 18.05.2022.
//

import UIKit

class CreateEditQuestionVC: UIViewController {
    
    var completionHandler: ((Question) -> Void)?
    var question = Question()
    var questionnarie = Questionnaire()
    var questionTextField = { () -> UITextField in
        let textfield = UITextField()
        textfield.layer.cornerRadius = 8
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.gray.cgColor
        return textfield
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if question.question.isEmpty {
            navigationItem.title = "Добавить вопрос"
            questionTextField.placeholder = "Введите свой вопрос"
        } else {
            navigationItem.title = "Изменить вопрос"
            questionTextField.text = question.question
        }
        
        self.title = "Добавить вопрос"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveQuestion))
        
        setupLayout()
    }
    
    func setupLayout () {
        
        view.addSubview(questionTextField)
        questionTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 30))
        
    }
    
    @objc func saveQuestion() {
        if RealmManager.shared.questionExists(question) {
            try! RealmManager.shared.localRealm.write {
                question.question = questionTextField.text!
            }
        } else {
            question.question = questionTextField.text!
            let lastID = Array(RealmManager.shared.localRealm.objects(Question.self).sorted(byKeyPath: "id", ascending: false))[0].id
            question.id = lastID + 1
            RealmManager.shared.saveQuestion(question: question)
            RealmManager.shared.saveQuestionIn(questionnarie: questionnarie, question: question)
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
