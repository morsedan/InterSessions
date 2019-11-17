//
//  SessionTableViewCell.swift
//  InterSessions
//
//  Created by morse on 11/11/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var finishedButton: UIButton!
    
    // MARK: - Properties
    
    var session: Session? {
        didSet {
            
            updateViews()
        }
    }
    
    func updateViews() {
        if let session = session {
            nameLabel.text = session.name
            switch session.finished {
            case true:
                finishedButton.setBackgroundImage(UIImage(named: "checked"), for: .normal)
            case false:
                finishedButton.setBackgroundImage(UIImage(named: "unchecked"), for: .normal)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func toggleFinished(_ sender: UIButton) {
        guard let session = session else { return }
        session.finished.toggle()
        session.editedTimeStamp = Date()
        CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        updateViews()
    }
}

extension SessionTableViewCell: SessionCheckedDelegate {
    func setFinished() {
        toggleFinished(UIButton())
    }
}
