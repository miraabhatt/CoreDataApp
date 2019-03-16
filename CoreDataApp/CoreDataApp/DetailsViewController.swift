//
//  DetailsViewController.swift
//  CoreDataApp
//
//  Created by Mira Bhatt on 3/16/19.
//  Copyright © 2019 Mira Bhatt. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var toDo: ToDo!
    
    @IBOutlet weak var completedView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        completedView.text = toDo.completed ? "Yes" : "No"
        textView.text = toDo.text
        
        let df = DateFormatter()
        
        df.timeStyle = .short
        df.dateStyle = .medium
        
        dateView.text = df.string(from: toDo.createdAt!)
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
