//
//  DataDefaultQuestions.swift
//  NewQuestionnaire
//
//  Created by Anastasia Legert on 18.05.2022.
//

import UIKit
import RealmSwift

class DataDefaultQuestions {
    
    lazy var lastIDQuestion: Int? = {
        var lastID = 0
        let arrayOfExistedQuestions = Array(RealmManager.shared.localRealm.objects(Question.self).sorted(byKeyPath: "id", ascending: false))
        if arrayOfExistedQuestions.count > 0 {
            lastID = arrayOfExistedQuestions[0].id
        }
        return lastID
    }()
    
    func getDefaultListOfQuestions () -> [Question] {
        
        let arrayOfStringQuestions = ["Как прошло ваше детство?",
                                      "Какое ваше самое яркое воспоминание?",
                                      "Расскажите о ваших путешествиях."
        ]
        
        var arrayOfQuestions: [Question] = []
        var id = 0
        if let lastIDQuestion = lastIDQuestion {
            id = lastIDQuestion + 1
        }
        for string in arrayOfStringQuestions {
            let newQuestion = Question(question: string)
            newQuestion.id = id
            id += 1
            arrayOfQuestions.append(newQuestion)
        }
        return arrayOfQuestions
    }
}


