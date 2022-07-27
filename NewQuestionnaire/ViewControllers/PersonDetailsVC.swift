//
//  PersonDetailsVC.swift
//  Memoria
//
//  Created by Anastasia Legert on 12.05.2022.
//


import UIKit
import RealmSwift

class PersonDetailsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var person = Person()
    
    var personImageView = UIImageView()
    
    var personNameLabel = { () -> UILabel in
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Беседы о персоне", "Беседы с персоной"])
        sc.selectedSegmentIndex = 0
        
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let addQuestionnarieButton = { () -> UIButton in
        let button = UIButton()
        button.setTitle("Создать новый опросник", for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(named: "GradientColor"), for: .highlighted)
        button.addTarget(self, action: #selector(createQuestionnarie), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Database
    
    var questionnariesForPerson: [Questionnaire] = []
    
    var questionnariesAboutPerson: [Questionnaire] = []
    
    // master array for segmentedControl
    lazy var rowsToDisplay = questionnariesAboutPerson
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestionnariesForPerson()
        loadQuestionnariesAboutPerson()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.title = "Выбранная персона"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPerson))
        
        if let personImage = person.image {
            personImageView.image = UIImage(named: personImage)
        } else {
            personImageView.image = UIImage(named: "noImage")
        }
        personImageView.contentMode = .scaleAspectFill
        personImageView.layer.cornerRadius = 10
        personImageView.layer.borderWidth = 1
        personImageView.layer.borderColor = UIColor.darkGray.cgColor
        personImageView.clipsToBounds = true
        
        personNameLabel.text = person.name
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(addQuestionnarieButton)
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        
    }
    
    @objc fileprivate func handleSegmentChange() {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            rowsToDisplay = questionnariesAboutPerson
        default:
            rowsToDisplay = questionnariesForPerson
        }
        
        tableView.reloadData()
    }
    
    @objc fileprivate func createQuestionnarie () {
        let viewController = CreateQuestionnarieVC()
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if rowsToDisplay == questionnariesAboutPerson {
            cell.textLabel?.text = rowsToDisplay[indexPath.row].interviewer?.name
            cell.imageView?.image = UIImage(named: rowsToDisplay[indexPath.row].interviewer?.image ?? "noImage")
        } else {
            cell.textLabel?.text = rowsToDisplay[indexPath.row].biography?.name
            cell.imageView?.image = UIImage(named: rowsToDisplay[indexPath.row].biography?.image ?? "noImage")
        }
        cell.imageView?.layer.cornerRadius = 20
        cell.imageView?.clipsToBounds = true
        cell.imageView?.contentMode = .scaleAspectFill
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let questionnarieTableVC = QuestionnarieTableVС()
        questionnarieTableVC.questionnarie = rowsToDisplay[indexPath.row]
        self.navigationController?.pushViewController(questionnarieTableVC, animated: true)
    }
    
    // MARK: - Setup Layout
    
    func setupLayout () {
        
        view.backgroundColor = .white
        let personInfoContainer = UIView()
        
        personInfoContainer.addSubview(personImageView)
        personInfoContainer.addSubview(personNameLabel)
        
        view.addSubview(personInfoContainer)
        
        personInfoContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        personInfoContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/6).isActive = true
        
        personImageView.anchor(top: personInfoContainer.topAnchor, leading: personInfoContainer.leadingAnchor, bottom: personInfoContainer.bottomAnchor, trailing: nil)
        personImageView.widthAnchor.constraint(equalTo: personInfoContainer.heightAnchor).isActive = true
        
        personNameLabel.anchor(top: personInfoContainer.topAnchor, leading: personImageView.trailingAnchor, bottom: personInfoContainer.bottomAnchor, trailing: personInfoContainer.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        
        segmentedControl.anchor(top: personInfoContainer.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        tableView.anchor(top: segmentedControl.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom:addQuestionnarieButton.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        addQuestionnarieButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: CGSize(width: 0, height: 50))
    }
    
    func loadQuestionnariesForPerson() {
        questionnariesForPerson = RealmManager.shared.getAllQuestionnariesFor(person: person) ?? []
        tableView.reloadData()
    }
    
    func loadQuestionnariesAboutPerson() {
        questionnariesAboutPerson = RealmManager.shared.getAllQuestionnariesAbout(person: person) ?? []
        tableView.reloadData()
    }
    
    @objc func editPerson() {
        let editPersonVC = CreateEditPersonVC()
        editPersonVC.person = person
        self.navigationController?.pushViewController(editPersonVC, animated: true)
    }
}

