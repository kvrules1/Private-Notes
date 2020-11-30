//
//  EntryViewController.swift
//  Private Notes
//
//  Created by KV on 9/23/20.
//  Copyright © 2020 Kenneth McDonald. All rights reserved.
//

import UIKit

// This class is for the view controller when creating a new note.
class EntryViewController: UIViewController {
    
    // Variables for title, category and note.
    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
    @IBOutlet var categoryField: UITextField!

    public var completion: ((String, String, String) -> Void)?
    
    // Function for when the controller loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates a border for the note field.
        self.noteField.layer.borderColor = UIColor.lightGray.cgColor
        self.noteField.layer.borderWidth = 1
       
        titleField.becomeFirstResponder()
        
        // Creates a save button.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    // Function for saving the new note.
    @objc func didTapSave(){
        if let text = titleField.text, !text.isEmpty, !noteField.text.isEmpty{
            completion?(text, categoryField.text!, noteField.text)
        }
    }

}
