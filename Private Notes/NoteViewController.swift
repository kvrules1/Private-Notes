//
//  NoteViewController.swift
//  Private Notes
//
//  Created by KV on 9/23/20.
//  Copyright © 2020 Kenneth McDonald. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var noteLabel: UITextView!

    public var noteTitle: String = ""
    public var note: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = noteTitle
        noteLabel.text = note

    }
    

}
