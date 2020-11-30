//
//  NoteViewController.swift
//  Private Notes
//
//  Created by KV on 9/23/20.
//  Copyright © 2020 Kenneth McDonald. All rights reserved.
//

import UIKit

// This class is for the view controller for viewing a note.
class NoteViewController: UIViewController {

    // Variables for the date, note, and category of the selected note.
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var noteLabel: UITextView!
    @IBOutlet var categoryField: UITextField!

    public var date: String = ""
    public var note: String = ""
    public var noteCategory: String = ""

    public var completion:((String, String)->Void)?
    
    // Function for when the controller loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates a border for the note field.
        self.noteLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.noteLabel.layer.borderWidth = 1
        
        // Displays the data stored for note, category, and date.
        dateLabel.text = date
        noteLabel.text = note
        categoryField.text = noteCategory
        
        // Creates a save button to save changes.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    // Function for saving changes to a previously made note.
    @objc func didTapSave(){
        if let text = noteLabel.text, !text.isEmpty, !categoryField.text!.isEmpty{
            completion?(text, categoryField.text!)
        }
    }
}
