//
//  MainTableViewController.swift
//  CoreDataApp
//
//  Created by Mira Bhatt on 2/2/19.
//  Copyright © 2019 Mira Bhatt. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func insertNewObject(_ sender:Any) {
        let alert = UIAlertController(title: "New Todo", message: "Enter details of new todo item", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter item description"
            textField.font = UIFont(name: "Charter Bold", size: 14)
            textField.textAlignment = NSTextAlignment.center
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let newTodo = ToDo(context: self.fetchedResultController.managedObjectContext)
            newTodo.createdAt = Date(timeIntervalSinceNow: 0)
            newTodo.text = alert.textFields?.first?.text ?? ""
            newTodo.completed = false
            
            do {
                try self.fetchedResultController.managedObjectContext.save()
            } catch let error {
                print("unable to save item due to \(error.localizedDescription)")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionInfo = fetchedResultController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todo = fetchedResultController.object(at: indexPath)
        cell.textLabel?.text = todo.text
        cell.detailTextLabel?.text = todo.createdAt?.description
    
        // Configure the cell...

        return cell
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let obj = fetchedResultController.object(at: indexPath)
            fetchedResultController.managedObjectContext.delete(obj)
            do {
                try fetchedResultController.managedObjectContext.save()
                
            }
            catch let error {
                print ("Could not delete \(obj.text ?? "") due to \(error.localizedDescription)")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier, identifier == "details" {
            let dest = segue.destination as! DetailsViewController
            dest.toDo = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
        }
        
    }


    var fetchedResultController: NSFetchedResultsController<ToDo> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController
        }
        
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        let sortDescriptors = [NSSortDescriptor(key: "completed", ascending: true), NSSortDescriptor(key: "createdAt", ascending: false)]
        
        fetchRequest.sortDescriptors = sortDescriptors
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        _fetchedResultsController.delegate = self
        
        do {
            try _fetchedResultsController.performFetch()
        } catch let error {
            print("\(error.localizedDescription)")
        }
            
            
        return _fetchedResultsController
        
    }

    
    var _fetchedResultsController:NSFetchedResultsController<ToDo>! = nil
}
