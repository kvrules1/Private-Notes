//
//  ViewController.swift
//  Private Notes
//
//  Created by KV on 9/23/20.
//  Copyright © 2020 Kenneth McDonald. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// This is the class for the main notes page
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    // The variables for the user, the model for notes, and the database reference.
    var user: User!
    var notes = [Note]()
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    // This function loads the main notes table and gets the Firebase userid for the session.
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        title = "Notes"
        
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        startObservingDatabase()
        
        self.label.isHidden = true
        self.table.isHidden = false
        
    }
    
    // Function for creating a new note note.
    @IBAction func didTapNewNote(){
        
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else{
            return
        }
        
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { noteTitle, category, note in
            self.navigationController?.popToRootViewController(animated: true)
            
            // Creates a key for the new note to be stored and accessed again.
            let key = Database.database().reference().child("users").child(self.user.uid).child("notes").childByAutoId().key
            
            // Saves the title of the new note to the database
            self.ref.child("users").child(self.user.uid).child("notes").child(key!).child("title").setValue(noteTitle)
            
            // Saves the actual note of the new note to the database.
            self.ref.child("users").child(self.user.uid).child("notes").child(key!).child("note").setValue(note)
            
            // Creates the date at the time of creation for the new note.
            let format = DateFormatter()
            format.dateStyle = .short
            format.timeStyle = .long
            let now = Date()
            
            // Saves the date of the new note to the database
            self.ref.child("users").child(self.user.uid).child("notes").child(key!).child("date").setValue(format.string(from: now))
            
            // Saves the category of the new note to the database.
            self.ref.child("users").child(self.user.uid).child("notes").child(key!).child("category").setValue(category)
            
            self.label.isHidden = true
            self.table.isHidden = false
            
            self.table.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Function for logging out of the app and Firebase
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "Logout", sender: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
                }
        }
    }
    
    // Function that
    func startObservingDatabase(){
        databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: {(snapshot) in
            var newNotes = [Note]()
            
            for noteSnapshot in snapshot.children{
                let note = Note(snapshot: noteSnapshot as! DataSnapshot)
                newNotes.append(note!)
            }
            
            self.notes = newNotes
            self.table.reloadData()
            
        })
    }
    
    // Function that returns the number of notes there are in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // Displays the notes in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].note
        return cell
    }
    
    // Function for sorting notes by title
    @IBAction func sortAlpha(_ sender: Any)
    {
        self.notes.sort { $0.title! < $1.title! }
        self.table.reloadData()
    }
    
    // Function for sorting notes by date
    @IBAction func sortDate(_ sender: Any)
    {
        self.notes.sort { $0.date.compare($1.date) == .orderedDescending }
        self.table.reloadData()
    }
    
    // Function for sorting notes by category
    @IBAction func sortCategory(_ sender: Any)
    {
        self.notes.sort { $1.category < $0.category }
        self.table.reloadData()
    }
    
    // Function for deleting notes from the application and database.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let note = notes[indexPath.row]
            note.ref?.removeValue()
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    // Function for viewing and editing notes shown in the table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = notes[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else {
            return
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = model.title
        vc.date = model.date
        vc.note = model.note
        vc.noteCategory = model.category
        
        // Updates the category and note in the database.
        vc.completion = {note, category in
            
            self.navigationController?.popToRootViewController(animated: true)

           
            self.ref.child("users").child(self.user.uid).child("notes").child(model.ref.key!).child("category").setValue(category)
            self.ref.child("users").child(self.user.uid).child("notes").child(model.ref.key!).child("note").setValue(note)
            
            self.table.reloadData()
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
