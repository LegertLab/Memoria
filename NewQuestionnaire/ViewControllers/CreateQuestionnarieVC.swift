//
//  Create&ChangeQuestionnarieVC.swift
//  Memoria
//
//  Created by Anastasia Legert on 17.05.2022.
//

import UIKit
import RealmSwift

class CreateQuestionnarieVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let personsNames = { () -> [String] in
        var array: [String] = []
        guard let persons = RealmManager.shared.getAllPersons() else { return array }
        for person in persons {
            array.append(person.name)
        }
        return array
    }()
    
    var choosenInterviewer = String()
    var choosenBiography = String()
    
    //MARK - Normal code
    let interviewerTextLabel = { () -> UILabel in
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Выберите, с кем будете беседовать:"
        return label
    }()
    
    let interviewerChoosenTextLabel = { () -> UILabel in
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Персона не выбрана"
        label.textColor = .gray
        return label
    }()
    
    let interviewerButton = { () -> UIButton in
        let button = UIButton()
        button.setTitle("Выбрать собеседника", for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(chooseInterviewer), for: .touchUpInside)
        return button
    }()
    
    let biographyTextLabel = { () -> UILabel in
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Выберите, о ком будете беседовать:"
        return label
    }()
    
    let biographyChoosenTextLabel = { () -> UILabel in
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Персона не выбрана"
        label.textColor = .gray
        return label
    }()
    
    let biographyButton = { () -> UIButton in
        let button = UIButton()
        button.setTitle("Выбрать биографию", for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(chooseBiography), for: .touchUpInside)
        return button
    }()
    
    let createQuestionnarieButton = { () -> UIButton in
        let button = UIButton()
        button.setTitle("Создать опросник", for: .normal)
        button.backgroundColor = UIColor(named: "GradientColor")
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveQuestionnarie), for: .touchUpInside)
        return button
    }()
    
    var interviewerStackView = UIStackView()
    var biographyStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Создание опросника"
        
        choosenInterviewer = personsNames[0]
        choosenBiography = personsNames[0]
        
        setupInterviewerStack()
        setupBiographyStack()
        setupLayout()
        
    }
    
    //MARK - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return personsNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return personsNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView is InterviewerPickerView {
            choosenInterviewer = personsNames[row]
        } else {
            choosenBiography = personsNames[row]
        }
    }
    
    fileprivate func setupInterviewerStack () {
        interviewerStackView = UIStackView(arrangedSubviews: [interviewerTextLabel, interviewerChoosenTextLabel, interviewerButton])
        interviewerStackView.distribution = .fillEqually
        interviewerStackView.layer.borderWidth = 1
        interviewerStackView.layer.cornerRadius = 10
        interviewerStackView.layer.borderColor = UIColor.gray.cgColor
        interviewerStackView.axis = .vertical
        
        view.addSubview(interviewerStackView)
        
        interviewerStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            bottom: nil,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24),
            size: CGSize(width: 0, height: 200)
        )
    }
    
    fileprivate func setupBiographyStack () {
        biographyStackView = UIStackView(arrangedSubviews: [biographyTextLabel, biographyChoosenTextLabel, biographyButton])
        biographyStackView.distribution = .fillEqually
        biographyStackView.layer.borderWidth = 1
        biographyStackView.layer.cornerRadius = 10
        biographyStackView.layer.borderColor = UIColor.gray.cgColor
        biographyStackView.axis = .vertical
        
        view.addSubview(biographyStackView)
        
        biographyStackView.anchor(
            top: interviewerStackView.bottomAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            bottom: nil,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24),
            size: CGSize(width: 0, height: 200)
        )
    }
    
    fileprivate func setupLayout () {
        view.backgroundColor = .white
        view.addSubview(createQuestionnarieButton)
        
        createQuestionnarieButton.anchor(
            top: nil,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)
        )
    }
    
    @objc
    private func chooseInterviewer () {
        let alert = UIAlertController(title: "Выбор персоны", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPresentation = true
        
        let pickerFrame = InterviewerPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            self.interviewerChoosenTextLabel.text = self.choosenInterviewer
            
        }))
        self.present(alert,animated: true, completion: nil )
    }
    
    @objc
    private func chooseBiography () {
        let alert = UIAlertController(title: "Выбор персоны", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPresentation = true
        
        let pickerFrame = BiographyPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            self.biographyChoosenTextLabel.text = self.choosenBiography
            
        }))
        self.present(alert,animated: true, completion: nil )
    }
    
    @objc private func saveQuestionnarie () {
        guard choosenInterviewer != "" && choosenBiography != "" else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        let personInterviewer = RealmManager.shared.getPersonByName(choosenInterviewer)
        let personBiography = RealmManager.shared.getPersonByName(choosenBiography)
        let newQuestionnarie = Questionnaire(biography: personBiography, interviewer: personInterviewer)
        
        let defaultQuestionsArray = DataDefaultQuestions().getDefaultListOfQuestions()
        for question in defaultQuestionsArray {
            newQuestionnarie.listOfQuestions.append(question)
        }
        RealmManager.shared.saveQuestionnarie(questionnarie: newQuestionnarie)
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    class InterviewerPickerView: UIPickerView {
        
    }
    
    class BiographyPickerView: UIPickerView {
        
    }
}
