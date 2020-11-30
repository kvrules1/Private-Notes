//
//  Note.swift
//  Private Notes
//
//  Created by KV on 11/18/20.
//  Copyright © 2020 Kenneth McDonald. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Class for the note item.
class Note {
    
    // Variables for the database reference, title, date, category, and note.
    var ref: DatabaseReference!
    var title: String!
    var note: String!
    var date: String!
    var category: String!
    
    // Creates a snapshot for the database.
    init ?(snapshot: DataSnapshot){
        if let data = snapshot.value as? [String: String]{
            ref = snapshot.ref
            
            title = data["title"] ?? ""
            note = data["note"] ?? ""
            category = data["category"] ?? ""
            date = (data["date"] ?? "") as String
        }
        else{
            return nil
        }
    }
    
}


