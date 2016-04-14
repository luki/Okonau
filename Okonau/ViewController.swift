//
//  ViewController.swift
//  Okonau
//
//  Created by Lukas A. Müller on 14/04/16.
//  Copyright © 2016 Lukas A. Müller. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tasksTableView: UITableView!
    let ref = Firebase(url: "http://okonau.firebaseIO.com")
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addButton(sender: AnyObject) {
        let alert = UIAlertController(title: "Creating a new task", message: nil, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (tf) in
            tf.placeholder = "What's your task?"
        }
        
        let a1 = UIAlertAction(title: "Add", style: .Cancel) { (action) in
            let textfield = alert.textFields![0] as UITextField
            let task = Task(taskName: textfield.text!, checked: false)
            let lala = self.ref.childByAppendingPath(textfield.text!)
            lala.setValue(task.toAnyObject())
        }
        
        alert.addAction(a1)
        
        let a2 = UIAlertAction(title: "Cancel", style: .Destructive) { (action) in
        }

        alert.addAction(a2)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tasksTableView.dequeueReusableCellWithIdentifier("taskCell") as! TaskTableViewCell
        return cell
    }


}

