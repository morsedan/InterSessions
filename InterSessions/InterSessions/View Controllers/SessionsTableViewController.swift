//
//  SessionsTableViewController.swift
//  InterSessions
//
//  Created by morse on 11/11/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit
import CoreData

class SessionsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    struct PropertyKeys {
        static let cell = "SessionCell"
        
        static let addSegue = "ShowAddSessionDetailSegue"
        static let detailSegue = "ShowDetailViewSegue"
        
        static let name = "name"
        static let noteText = "noteText"
        static let finished = "finished"
        static let editedTimeStamp = "editedTimeStamp"
        static let createdTimeStamp = "createdTimeStamp"
        static let identifier = "identifier"
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Session> = {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: PropertyKeys.finished, ascending: true),
                                        NSSortDescriptor(key: PropertyKeys.editedTimeStamp, ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: PropertyKeys.finished, cacheName: nil)
        
        frc.delegate = self
        
        try! frc.performFetch()
        
        return frc
    }()
    
    
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let number = fetchedResultsController.sections?[section].name else { return ""}
        switch number {
        case "0":
            return "Unfinished: "
        default:
            return "Finished: "
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.cell, for: indexPath) as? SessionTableViewCell else { return UITableViewCell() }
        
        let session = fetchedResultsController.object(at: indexPath)

        cell.session = session

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let session = fetchedResultsController.object(at: indexPath)
            CoreDataStack.shared.mainContext.delete(session)
            CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Actions

    @IBAction func uncheckAll(_ sender: Any) {
        _ = fetchedResultsController.fetchedObjects?.compactMap({ session in
            if session.finished {
                session.finished.toggle()
            }
        })
        CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertyKeys.detailSegue {
            guard let detailVC = segue.destination as? SessionDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.delegate = sender as? SessionTableViewCell
            detailVC.session = fetchedResultsController.object(at: indexPath)
        }
    }
}

// MARK: - Extensions

extension SessionsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
    }
}
