//
//  PersonListVC.swift
//  Memoria
//
//  Created by Anastasia Legert on 11.05.2022.
//

import UIKit
import RealmSwift

class PersonListVC: UITableViewController {
    var persons: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPersonTapped))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "personListCell")
        self.title = "Моя семья"
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        guard let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:
                                                            FileManager.SearchPathDomainMask.userDomainMask).first else  {return }
        print(directoryURL.path)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadPersons()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personListCell", for: indexPath)
        cell.textLabel?.text = persons?[indexPath.row].name ?? "Ни одна персона пока не добавлена"
        cell.imageView?.image = UIImage(named: persons?[indexPath.row].image ?? "noImage")
        cell.imageView?.layer.cornerRadius = 20
        cell.imageView?.clipsToBounds = true
        cell.imageView?.contentMode = .scaleAspectFill
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personDetailsVC = PersonDetailsVC()
        guard let person = persons?[indexPath.row] else { return }
        personDetailsVC.person = person
        self.navigationController?.pushViewController(personDetailsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        guard let movedPerson = persons?[fromIndexPath.row] else { return }
        persons?.remove(at: fromIndexPath.row)
        persons?.insert(movedPerson, at: to.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let deletedPerson = persons![indexPath.row]
        RealmManager.shared.deletePerson(person: deletedPerson)
        persons?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    func loadPersons() {
        persons = RealmManager.shared.getAllPersons()
        tableView.reloadData()
    }
    
    @objc private func addPersonTapped () {
        let addPersonVC = CreateEditPersonVC()
        self.navigationController?.pushViewController(addPersonVC, animated: true)
    }
}


