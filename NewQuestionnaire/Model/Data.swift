//
//  Model.swift
//  Memoria
//
//  Created by Anastasia Legert on 06.05.2022.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted var userName: String = ""
    @Persisted var userEmail: String = ""
    @Persisted var userPassword: String = ""
    
    convenience init(userName: String, userEmail: String) {
        self.init()
        self.userName = userName
        self.userEmail = userEmail
    }
}

class Person: Object {
    @Persisted var name: String = ""
    @Persisted var image: String?
    @Persisted var id: String = ""
    @Persisted(originProperty: "biography") var personAsBiography: LinkingObjects<Questionnaire>
    @Persisted(originProperty: "interviewer") var personAsInterviewer: LinkingObjects<Questionnaire>
    
    convenience init(name: String, image: String? = nil) {
        self.init()
        self.name = name
        self.image = image
    }
}

enum LifeStage: String, PersistableEnum, CaseIterable {
    case birth = "Рождение и младенчество"
    case earlyСhildhood = "Раннее детство"
    case preschool = "Дошкольный возраст"
}

enum Fact: String, PersistableEnum, CaseIterable {
    case main = "Основной блок"
    case geography = "География"
    case family = "Семейное положение"
}

enum LifeSphere: String, PersistableEnum, CaseIterable {
    case family = "Семья"
    case friends = "Друзья"
    case work = "Работа"
}

enum StatusOfQuestion: String, PersistableEnum {
    case active
    case done
}

class ContentForQuestion: Object {
    @Persisted var images: String = ""
    @Persisted var audio: String = ""
    @Persisted var text: String = ""
}

class Question: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var question: String = ""
    @Persisted var content: ContentForQuestion?
    @Persisted var facts: List<Fact>
    @Persisted var lifeStages: List<LifeStage>
    @Persisted var lifeSpheres: List<LifeSphere>
    
    convenience init (question: String) {
        self.init()
        self.question = question
    }
}

class Questionnaire: Object {
    @Persisted var biography: Person?
    @Persisted var interviewer: Person?
    @Persisted var choosenFacts: List<Fact>
    @Persisted var choosenLifeStages: List<LifeStage>
    @Persisted var choosenLifeSpheres: List<LifeSphere>
    @Persisted var listOfQuestions: List<Question>
    
    convenience init (biography: Person, interviewer: Person) {
        self.init()
        self.biography = biography
        self.interviewer = interviewer
    }
}

class Sound: Object {
    @Persisted var noteID: String = ""
    @Persisted var noteTitle: String = "" // удалить
    @Persisted var noteSoundURL: String = ""
    @Persisted var noteSoundTitle: String = ""
}
