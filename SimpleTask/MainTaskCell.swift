//
//  MainTaskCell.swift
//  SimpleTask
//
//  Created by Ty Schultz on 12/2/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit

class MainTaskCell: UITableViewCell {
    
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addNote(note : Note) {
        
        let noteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
        noteLabel.text = note.content
        noteLabel.heightAnchor.constraintGreaterThanOrEqualToConstant(20).active = true
        noteLabel.numberOfLines = 0
        noteLabel.font = UIFont(name: "Avenir Book", size: 15)
        self.stackView.addArrangedSubview(noteLabel)
        
    }

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!

}
