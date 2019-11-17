//
//  SessionDetailViewController.swift
//  InterSessions
//
//  Created by morse on 11/11/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

class SessionDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var fieldView: UIView!
    
    
    // MARK: - Properties
    
    var session: Session?
    var delegate: SessionCheckedDelegate?
    var saveTapped = false

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        updateViews()
        if session == nil {
            nameTextField.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !saveTapped {
            saveTapped(self)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func finishedTapped(_ sender: Any) {
        if let session = session {
            delegate?.setFinished()
            updateViews()
            
            if session.finished {
                navigationController?.popViewController(animated: true)
            }
        } else {
            finishedButton.isHidden = true
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
            let notes = notesTextView.text else { return }
        
        saveTapped.toggle()
        
        if let session = session {
            session.name = name
            session.noteText = notes
//            session.editedTimeStamp = Date()
        } else {
            Session(name: name, noteText: notes, finished: false, createdTimeStamp: Date())
        }

        
        CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private
    
    private func updateViews() {
        updateUI()
        title = session?.name ?? "Create Session"
        nameTextField.text = session?.name
        notesTextView.text = session?.noteText
        switch session?.finished {
        case true:
            finishedButton.setImage(UIImage(named: "checked"), for: .normal)
        case false:
            finishedButton.setImage(UIImage(named: "unchecked"), for: .normal)
        default: return
        }
    }
    
    private func updateUI() {
        notesTextView.layer.cornerRadius = 4
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor(displayP3Red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0).cgColor
        
        fieldView.layer.cornerRadius = 4
        fieldView.layer.borderWidth = 1
        fieldView.layer.borderColor = UIColor(displayP3Red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0).cgColor
    }
}

extension SessionDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        notesTextView.becomeFirstResponder()
        return true
    }
}
