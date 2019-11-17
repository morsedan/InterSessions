//
//  CoreDataStack.swift
//  InterSessions
//
//  Created by morse on 11/11/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // Let us access the CoreDataStack from anywhere in the app.
    static let shared = CoreDataStack()
    
    // Set up a persistent container
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Session")
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // Create easy access to the moc (managed object context)
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            // FIXME: It this fails, an alert should present to let the user know.
            NSLog("Error saving context: \(error)")
            context.reset()
        }
    }
//    
//    func saveToPersistentStore() {
//        do {
//            try mainContext.save()
//        } catch {
//            NSLog("Error saving context: \(error)")
//            mainContext.reset()
//        }
//    }
}
