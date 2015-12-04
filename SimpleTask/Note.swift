//
//  Note.swift
//  SimpleTask
//
//  Created by Ty Schultz on 12/2/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import RealmSwift

class Note: Object {
    
    
    dynamic var content = ""
    dynamic var item : Item?

}

