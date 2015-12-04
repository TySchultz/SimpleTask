//
//  ManageNoteViewController.swift
//  SimpleTask
//
//  Created by Ty Schultz on 12/3/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift

class ManageNoteViewController: UITableViewController {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var createBTN: UIButton!
      var pullDownLabel: UILabel!
      var pullDownLine: UIView!

    @IBOutlet weak var taskContent: UILabel!
    private weak var currentTask : Item!
    
    
    var headerHeight :CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        
        self.view.bringSubviewToFront(createBTN)

        taskContent.text = currentTask.content
        setup()
    }

    
    var task: Item? {
        didSet {
            currentTask = task
        }
    }
    
    
    func setup () {
        
        let pullPosition = taskContent.frame.maxY + 60
        
        pullDownLabel = UILabel(frame: CGRect(x: 0, y: pullPosition, width: view.frame.size.width, height: 20))
        pullDownLabel.textColor = UIColor.whiteColor()
        pullDownLabel.text = "Swipe down to go back"
        pullDownLabel.font = UIFont(name: "Avenir Book", size: 12)
        pullDownLabel.textAlignment = NSTextAlignment.Center
        pullDownLabel.alpha = 0.0
        header.addSubview(pullDownLabel)
        
        
        pullDownLine = UIView()
        pullDownLine.frame = CGRectMake(150, pullPosition + 13, 1, 1);
        pullDownLine.backgroundColor = UIColor.whiteColor()
        pullDownLine.center = CGPoint(x: header.center.x, y: -10)
        header.addSubview(pullDownLine)
        
        UIApplication.sharedApplication().statusBarFrame
        
    }
    
    @IBAction func createNote(sender: UIButton) {
        
        let realm = try! Realm()
        let blank = Note()
        blank.content = textField.text!
        blank.item = currentTask
        try! realm.write {
            realm.add(blank)
        }
        
        textField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true

    }
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false

    }
    
    override func viewDidAppear(animated: Bool) {
        headerHeight = header.frame.size.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        print(yPosition)
        
        //Create sticky and expanding header
        if yPosition < 0 {
            var headerFrame = header.frame
            headerFrame.origin.y = yPosition
            headerFrame.size.height = headerHeight - yPosition
            header.frame = headerFrame
        }
        let pullPosition = taskContent.frame.maxY + 60
        self.pullDownLabel.center = CGPointMake(header.center.x, pullPosition )

        //Show progress of pull down
        if (yPosition < 0 && yPosition > -90) {
            self.pullDownLine.alpha = 1
            self.pullDownLabel.alpha = 1
            self.pullDownLine.frame = CGRectMake((self.view.frame.size.width/2)-60, pullPosition + 13, -yPosition*1.35, 1)
        }else if (yPosition > 0){
            self.pullDownLine.alpha = 0
            self.pullDownLabel.alpha = 0
            self.pullDownLine.frame = CGRectMake((self.view.frame.size.width/2)-60, pullPosition + 13, 0, 1)
        }
        
        if (yPosition < -100) {
            textField.resignFirstResponder()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
