//
//  Session+Convenience.swift
//  InterSessions
//
//  Created by morse on 11/11/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation
import CoreData

extension Session {
    @discardableResult convenience init(name: String, noteText: String, finished: Bool = false, editedTimeStamp: Date = Date(), createdTimeStamp: Date, identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.name = name
        self.noteText = noteText
        self.finished = finished
        self.editedTimeStamp = editedTimeStamp
        self.createdTimeStamp = createdTimeStamp
        self.identifier = identifier
    }
}
