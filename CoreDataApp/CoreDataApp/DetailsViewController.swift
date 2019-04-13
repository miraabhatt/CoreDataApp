//
//  DetailsViewController.swift
//  CoreDataApp
//
//  Created by Mira Bhatt on 3/16/19.
//  Copyright © 2019 Mira Bhatt. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    var toDo: ToDo!
    var indexPath: IndexPath!
    @IBOutlet weak var completedAtLabel: UILabel!
    @IBOutlet weak var completedButton: UIBarButtonItem!
    @IBOutlet weak var completedView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBAction func completeOrReopen(_ sender: Any) {
        if toDo.completed {
            // add code to reopen
            toDo.completed = false
            toDo.completedAt = nil 
        } else {
            // add code to complete
            toDo.completed = true
            toDo.completedAt = Date(timeIntervalSinceNow: 0)
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        updateCompletedLabels()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textView.text = toDo.text
        
        let df = DateFormatter()
        
        df.timeStyle = .short
        df.dateStyle = .medium
        
        dateView.text = df.string(from: toDo.createdAt!)
        
        updateCompletedLabels()
    }
    @IBAction func dismissKeyboard(_ sender: Any) {
        textView.endEditing(true)
        toDo.text = textView.text
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    func updateCompletedLabels() {
        let df = DateFormatter()
        
        df.timeStyle = .short
        df.dateStyle = .medium
        completedAtLabel.text = toDo.completed ? df.string(from: toDo.completedAt!) : "Not Yet"
        completedView.text = toDo.completed ? "Yes" : "No"
        completedButton.title = toDo.completed ? "Redo" : "Complete"
        if toDo.completed {
            textView.isEditable = false
        } else {
            textView.isEditable =
                true
        }
    }

    @IBAction func trashCanPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Delete?", message: "Would you like to delete this todo item?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "unwindAndDelete", sender: self)
            
            }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
