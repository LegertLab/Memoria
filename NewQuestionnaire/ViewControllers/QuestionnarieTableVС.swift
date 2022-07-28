//
//  QuestionnarieTableVС.swift
//  Memoria
//
//  Created by Anastasia Legert on 18.05.2022.
//

import UIKit
import RealmSwift

class QuestionnarieTableVС: UITableViewController {
    
    var questionnarie: Questionnaire? = nil
    var arrayOfQuestions: [Question]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Опросник"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addQuestionTapped))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        guard  let questionnarie = questionnarie else { return }
        arrayOfQuestions = Array(questionnarie.listOfQuestions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionnarie?.listOfQuestions.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let arrayOfQuestions = arrayOfQuestions else {
            cell.textLabel?.text = "Ни одного вопроса нет"
            return cell
        }
        cell.textLabel?.text = arrayOfQuestions[indexPath.row].question
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let questionMediaContentVC = QuestionVC()
        guard let arrayOfQuestions = arrayOfQuestions else { return }
        questionMediaContentVC.title = arrayOfQuestions[indexPath.row].question
        questionMediaContentVC.question = arrayOfQuestions[indexPath.row]
        let contentForQuestion = ContentForQuestion()
        contentForQuestion.text = "тут какой-то введенный уже ранее текст"
        
        if questionMediaContentVC.question.content == nil {
            try! RealmManager.shared.localRealm.write {
                questionMediaContentVC.question.content = contentForQuestion
            }
        }
        self.navigationController?.pushViewController(questionMediaContentVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let tappedQuestion = arrayOfQuestions?[indexPath.row] else {
            return nil }
        
        let actionEditInstance = UIContextualAction(style: .normal, title: "Изменить") { _,_,_ in
            let editVC = CreateEditQuestionVC()
            editVC.question = tappedQuestion
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        
        let actionsConfiguration = UISwipeActionsConfiguration(actions: [actionEditInstance])
        return actionsConfiguration
    }
    
//    func editQuestionWithСlosure(question: Question) {
//    let editScreen = CreateEditQuestionVC()
//    editScreen.question = question
//    editScreen.completionHandler = { [unowned self] updatedQuestion in
//    question = updatedQuestion
//    }
//    self.navigationController?.pushViewController(editScreen, animated: true)
//    }
    
    @objc private func addQuestionTapped () {
        let addQuestionVC = CreateEditQuestionVC()
        addQuestionVC.questionnarie = questionnarie!
        self.navigationController?.pushViewController(addQuestionVC, animated: true)
    }
}
