//
//  QuestionVC.swift
//  Memoria
//
//  Created by Anastasia Legert on 18.05.2022.
//

import UIKit

class QuestionVC: UIViewController {
    
    var question: Question!
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Текст", "Фото", "Аудио"])
        sc.selectedSegmentIndex = 0
        
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    var contentObject: ContentForQuestion!
    
    lazy var noteVC = NoteVC()
    lazy var photoVC = PhotoVC()
    lazy var audioVC = AudioVC()
    
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        contentObject = question.content
        
        
        view.addSubview(segmentedControl)
        view.addSubview(contentView)
        setupLayout()
        noteVC.contentText = contentObject.text
        noteVC.contentObject = contentObject
        displayContentController(noteVC)
    }
    
    func setupLayout () {
        segmentedControl.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        contentView.anchor(top: segmentedControl.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        contentView.backgroundColor = .gray
    }
    
    @objc fileprivate func handleSegmentChange() {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            contentView.subviews.forEach({ $0.removeFromSuperview() })
            noteVC.contentText = contentObject.text
            displayContentController(noteVC)
        case 1:
            contentView.subviews.forEach({ $0.removeFromSuperview() })
            photoVC.contentImageUrl = contentObject.images
            photoVC.contentObject = contentObject
            displayContentController(photoVC)
        case 2:
            contentView.subviews.forEach({ $0.removeFromSuperview() })
            audioVC.contentObject = contentObject
            displayContentController(audioVC)
        default:
            return
        }
    }
    
    func displayContentController(_ contentVC: UIViewController) {
        addChild(contentVC)
        contentVC.view.frame = contentView.bounds
        contentView.addSubview(contentVC.view)
        contentVC.didMove(toParent: self)
    }
}
