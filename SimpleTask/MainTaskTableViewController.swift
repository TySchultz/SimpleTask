//
//  MainTaskTableViewController.swift
//  SimpleTask
//
//  Created by Ty Schultz on 12/2/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift

let estimatedHeight: CGFloat = 150


class MainTaskTableViewController: UITableViewController {

    
    var tasks : Results<Item>!
    var realm : Realm!
    private  var addTaskView: UIView!
    private  var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create navigation style
        navigationController!.navigationBar.barTintColor = TDRed
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        //Self sizing cells
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        
        realm = try! Realm()
    }
    
    override func viewWillAppear(animated: Bool) {
        tasks = realm.objects(Item)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! MainTaskCell
        
        let objects = realm.objects(Note).filter("item == %@", tasks[indexPath.row])
        
        let title = tasks[indexPath.row].content
        cell.title = title
        
        if cell.stackView.arrangedSubviews.count != objects.count {
            for view in cell.stackView.arrangedSubviews {
                cell.stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            for note in objects {
                cell.addNote(note)
            }
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let testView = storyboard.instantiateViewControllerWithIdentifier("TestView") as! EditCellViewController

        testView.task = tasks[indexPath.row]
        testView.mainViewController = self
        testView.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0)
        testView.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        UIView.animateWithDuration(0.1) { () -> Void in
            testView.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.65)
        }
        self.presentViewController(testView, animated: true) { () -> Void in
        
        }
    }


    @IBAction func addTask(sender: UIBarButtonItem) {
        
        addTaskView = UIView(frame: CGRect(x: 0, y: -400, width: view.frame.size.width, height: self.view.frame.size.height))
        addTaskView.backgroundColor = TDRed
        let currentWindow = UIApplication.sharedApplication().keyWindow
        currentWindow?.addSubview(addTaskView)
        
        textField = UITextField(frame: CGRect(x: 16, y: 40, width: addTaskView.frame.size.width-32, height: 40))
        textField.font = UIFont(name: "Avenir Book", size: 17.0)
        textField.textColor = UIColor.whiteColor()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Task", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.6)])
        
        let lineSeperator = UIView(frame: CGRect(x: 16, y: 80, width: view.frame.size.width-32, height: 1))
        lineSeperator.backgroundColor = UIColor.blackColor()
        addTaskView.addSubview(lineSeperator)
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 80, width: view.frame.size.width/2, height: 45))
        closeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeButton.setTitle("X", forState: UIControlState.Normal)
        closeButton.titleLabel?.font = UIFont(name: "Avenir Book", size: 20)
        closeButton.addTarget(self, action: "closeAddTaskView:", forControlEvents: UIControlEvents.TouchUpInside)
        addTaskView.addSubview(closeButton)
        
        let enterButton = UIButton(frame: CGRect(x: view.frame.midX, y: 80, width: view.frame.size.width/2, height: 45))
        enterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        enterButton.setTitle("✓", forState: UIControlState.Normal)
        enterButton.titleLabel?.font = UIFont(name: "Avenir Book", size: 20)
        enterButton.addTarget(self, action: "addNewTask:", forControlEvents: UIControlEvents.TouchUpInside)
        addTaskView.addSubview(enterButton)
        
        addTaskView.addSubview(textField)
        textField.becomeFirstResponder()
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.addTaskView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        }
    }
    
    
    func closeAddTaskView (sender : UIButton) {

        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.addTaskView.frame = CGRectMake(0, -400, self.view.frame.size.width, self.view.frame.size.height)
            self.textField.resignFirstResponder()
            }) { (Bool) -> Void in
                self.addTaskView.removeFromSuperview()
        }
    }
    
    func addNewTask (sender : UIButton) {
        
        let newTask = Item()
        newTask.content = textField.text!
        try! realm.write {
            self.realm.add(newTask)
        }
        tasks = realm.objects(Item)
        
        tableView.reloadData()

        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.addTaskView.frame = CGRectMake(0, -128, self.view.frame.size.width, 128)
            self.textField.resignFirstResponder()
            }) { (Bool) -> Void in
                self.addTaskView.removeFromSuperview()
        }
    }
    
    @IBAction func addNoteToTask(sender: UIButton) {
        let view = sender.superview!
        let cell = view.superview as! MainTaskCell
        let indexPath = tableView.indexPathForCell(cell)
        
        let item = tasks[indexPath!.row]
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let manageNotesViewController = storyboard.instantiateViewControllerWithIdentifier("ManageNotes") as! ManageNoteViewController
        manageNotesViewController.task = item
        self.presentViewController(manageNotesViewController, animated: true, completion: nil)
    }
    
    
    func deleteCell(){
        tableView.deleteRowsAtIndexPaths([tableView.indexPathForSelectedRow!], withRowAnimation: UITableViewRowAnimation.Top)
    }
   
    
}
