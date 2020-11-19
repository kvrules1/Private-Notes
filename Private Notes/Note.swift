//
//  Note.swift
//  Private Notes
//
//  Created by KV on 11/18/20.
//  Copyright © 2020 Kenneth McDonald. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Note {
    var ref: DatabaseReference!
    var title: String!
    var note: String!
    var date: String!
    var category: String!
    
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


