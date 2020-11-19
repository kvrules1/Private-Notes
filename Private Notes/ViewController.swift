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
import DropDown

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //var models: [(title: String, note: String, date: Date)] = []
    
    var user: User!
    var notes = [Note]()
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    
    

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
    
    
    @IBAction func didTapNewNote(){
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else{
            return
        }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { noteTitle, category, note in
            self.navigationController?.popToRootViewController(animated: true)
            //self.notes.append((title: noteTitle, note: note, date: Date()))
            
            let randomID = Database.database().reference().child("users").child(self.user.uid).child("notes").childByAutoId()
            
            self.ref.child("users").child(self.user.uid).child("notes").child(randomID.key!).child("title").setValue(noteTitle)
            
            self.ref.child("users").child(self.user.uid).child("notes").child(randomID.key!).child("note").setValue(note)
            
            let format = DateFormatter()
            format.dateStyle = .full
            format.timeStyle = .full
            let now = Date()
            
            self.ref.child("users").child(self.user.uid).child("notes").child(randomID.key!).child("date").setValue(format.string(from: now))
            
            self.ref.child("users").child(self.user.uid).child("notes").child(randomID.key!).child("category").setValue(category)
        
            
            self.label.isHidden = true
            self.table.isHidden = false
            
            self.table.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                //present(vc, animated: true, completion: nil)
                self.performSegue(withIdentifier: "Logout", sender: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
                }
        }
    }
    
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
    
    // Table Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].note
        return cell
    }
    // Allows for reorder
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let item = notes[sourceIndexPath.row]
        notes.remove(at: sourceIndexPath.row)
        notes.insert(item, at: destinationIndexPath.row)
    }
    
    @IBAction func sortAlpha(_ sender: Any)
    {
        self.notes.sort { $0.title! < $1.title! }
        self.table.reloadData()
    }
    
    @IBAction func sortDate(_ sender: Any)
    {
        self.notes.sort { $0.date < $1.date }
        self.table.reloadData()
    }
    
    @IBAction func sortCategory(_ sender: Any)
    {
        self.notes.sort { $0.category < $1.category }
        self.table.reloadData()
    }
    
    @IBAction func edit(_ sender: Any)
    {
        table.isEditing = !table.isEditing
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = notes[indexPath.row]
        
        // Show note controller
        
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = model.title
        vc.date = model.date
        vc.note = model.note
        vc.noteCategory = model.category
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
