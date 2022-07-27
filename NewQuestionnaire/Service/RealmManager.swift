//
//  RealmManager.swift
//  Memoria
//
//  Created by Anastasia Legert on 12.05.2022.
//

import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    private init() {}
    
    let localRealm = try! Realm()
    
    func getAllPersons () -> [Person]? {
        let persons = Array(localRealm.objects(Person.self))
        if persons != [] {
            return persons
        } else {
            return nil
        }
    }
    
    func getAllQuestionnariesFor (person: Person) -> [Questionnaire]? {
        let questionnaries = Array(localRealm.objects(Questionnaire.self).where{$0.interviewer.name == person.name})
        if questionnaries != [] {
            return questionnaries
        } else {
            return nil
        }
    }
    
    func getAllQuestionnariesAbout (person: Person) -> [Questionnaire]? {
        let questionnaries = Array(localRealm.objects(Questionnaire.self).where{$0.biography.name == person.name})
        if questionnaries != [] {
            return questionnaries
        } else {
            return nil
        }
    }
    
    func savePerson (person: Person) {
        try! localRealm.write {
            localRealm.add(person)
        }
    }
    
    func saveQuestion (question: Question) {
        try! localRealm.write {
            localRealm.add(question)
        }
    }
    
    func deletePerson (person: Person) {
        try! localRealm.write {
            localRealm.delete(person)
        }
    }
    
    func getPersonByName (_ textName: String) -> Person {
        let person = Array(localRealm.objects(Person.self).where{$0.name == textName})[0]
        return person
    }
    
    func saveQuestionnarie (questionnarie: Questionnaire) {
        try! localRealm.write {
            localRealm.add(questionnarie)
        }
    }
    
    func saveSound (sound: Sound) {
        try! localRealm.write {
            localRealm.add(sound)
        }
    }
    
    func saveContentObject (contentObject: ContentForQuestion) {
        try! localRealm.write {
            localRealm.add(contentObject)
        }
    }
    
    func personExists (_ person: Person) -> Bool {
        let personFilteredArray = Array(localRealm.objects(Person.self).where{$0.name == person.name})
            if personFilteredArray != [] {
                return true
            } else {
                return false
            }
        }
    
    func questionExists (_ question: Question) -> Bool {
        let questionFilteredArray = Array(localRealm.objects(Question.self).where{$0.question == question.question})
            if questionFilteredArray != [] {
                return true
            } else {
                return false
            }
    }
    
    func saveQuestionIn(questionnarie: Questionnaire, question:Question) {
        try! localRealm.write {
            questionnarie.listOfQuestions.append(question)
        }
    }
}
