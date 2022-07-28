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
        
        let arrayOfStringQuestions = ["Где и когда вы родились?",
                                      "В каких условиях на момент вашего рождения жила ваша семья? Опишите свой первый дом в деталях, которые знаете.",
                                      "Какие ваши самые первые детские воспоминания?",
                                      "Какие праздники в семье любили отмечать больше всего? Какие у вас были особенные семейные традиции?",
                                      "Как складывались отношения с братьями-сестрами?",
                                      "Кто были вашими друзьями детства? Как познакомились с ними, почему стали дружить?",
                                      "Как проводили летние каникулы в детстве? Ездили в детские лагеря, к бабушке, на море?",
                                      "Как был организован ваш быт, будни, выходные?"
                                      
                                    
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


