//
//  EditCellViewController.swift
//  SimpleTask
//
//  Created by Ty Schultz on 12/4/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift
class EditCellViewController: UIViewController {

    @IBOutlet weak var taskContent: UILabel!
    @IBOutlet weak var holder: UIView!
    @IBOutlet weak var notesStackView: UIStackView!
    private weak var currentTask : Item!
    var notes : Results<Note>!
    var realm : Realm!
    var mainViewController : MainTaskTableViewController!

    
    var task: Item? {
        didSet {
            currentTask = task
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        notes = realm.objects(Note).filter("item == %@", currentTask)
        
        var index = 0
        for note in notes {
            addNoteToStack(note, index: index)
            index++
        }
        
        taskContent.text = currentTask.content
        holder.layer.cornerRadius = 4.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNoteToStack(note : Note, index : Int) {
        let noteLabel = UIButton(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
        noteLabel.setTitle(note.content, forState: UIControlState.Normal)
        noteLabel.titleLabel?.font = UIFont(name: "Avenir Book", size: 15.0)
        noteLabel.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        noteLabel.addTarget(self, action: "deleteNote:", forControlEvents: UIControlEvents.TouchUpInside)
        noteLabel.heightAnchor.constraintEqualToConstant(20).active = true
        noteLabel.tag = index
        self.notesStackView.addArrangedSubview(noteLabel)
    }
    
    @IBAction func donePressed(sender: AnyObject) {
    
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0)
            }) { (Bool) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func deleteTask(sender: AnyObject) {
        
        try! self.realm.write {
            self.realm.delete(self.currentTask)
            for note in self.notes {
                self.realm.delete(note)
            }
        }

        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0)
            }) { (Bool) -> Void in
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.mainViewController.deleteCell()
            })
        }
    }
    
    func deleteNote(sender : UIButton){
        let note = notes.filter("content == %@", (sender.titleLabel?.text)!)
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            sender.hidden = true
            }) { (Bool) -> Void in
                self.notesStackView.removeArrangedSubview(sender)
                sender.removeFromSuperview()
                try! self.realm.write {
                    self.realm.delete(note)
                }
        }
    }



}
