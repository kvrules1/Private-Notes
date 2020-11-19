//
//  NoteViewController.swift
//  Private Notes
//
//  Created by KV on 9/23/20.
//  Copyright © 2020 Kenneth McDonald. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var noteLabel: UITextView!
    @IBOutlet var categoryField: UITextField!

    public var date: String = ""
    public var note: String = ""
    public var noteCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noteLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.noteLabel.layer.borderWidth = 1
        
        dateLabel.text = date
        noteLabel.text = note
        categoryField.text = noteCategory
        

    }
    

}
