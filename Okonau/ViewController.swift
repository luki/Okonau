//
//  ViewController.swift
//  Okonau
//
//  Created by Lukas A. Müller on 14/04/16.
//  Copyright © 2016 Lukas A. Müller. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tasksTableView: UITableView!
    let ref = Firebase(url: "http://okonau.firebaseIO.com")
    var tasks = [Task]()
    
    let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        
        tasksTableView.addSubview(refresher)
        refresher.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    }
    
    @IBAction func addButton(sender: AnyObject) {
        let alert = UIAlertController(title: "Creating a new task", message: nil, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (tf) in
            tf.placeholder = "What's your task?"
        }
        
        let a1 = UIAlertAction(title: "Add", style: .Cancel) { (action) in
            let textfield = alert.textFields![0] as UITextField
            let task = Task(key: "23", taskName: textfield.text!, checked: false)
            let lala = self.ref.childByAppendingPath(textfield.text!)
            lala.setValue(task.toAnyObject())
        }
        
        alert.addAction(a1)
        
        let a2 = UIAlertAction(title: "Cancel", style: .Destructive) { (action) in
        }

        alert.addAction(a2)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func retrieveData() {
        ref.observeEventType(.Value, withBlock: { (snapshot) in
            
            var newTasks = [Task]()
            
            for task in snapshot.children {
                let task = Task(snapshot: task as! FDataSnapshot)
                newTasks.append(task)
            }
            
            self.tasks = newTasks
            self.tasksTableView.reloadData()
            
        })
        
    }
    
    func refresh(sender: UIRefreshControl) {
        
        sender.beginRefreshing()
        retrieveData()
        sender.endRefreshing()
        
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tasksTableView.dequeueReusableCellWithIdentifier("taskCell") as! TaskTableViewCell
        cell.taskLabel.text = tasks[indexPath.row].taskName
        if tasks[indexPath.row].checked == true {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let toRemoveValue = tasks[indexPath.row]
        toRemoveValue.ref?.removeValue()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var task = tasks[indexPath.row]
        
        if let cell = tasksTableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                task.checked = false
                task.ref?.updateChildValues(["checked": false])
            } else {
                cell.accessoryType = .Checkmark
                task.checked = true
                task.ref?.updateChildValues(["checked": true])
            }
        }
        
        tasks[indexPath.row] = task
        print(tasks[indexPath.row].checked)
        
    }


}