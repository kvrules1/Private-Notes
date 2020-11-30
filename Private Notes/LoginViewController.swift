//
//  LoginViewController.swift
//  Private Notes
//
//  Created by KV on 9/23/20.
//  Copyright © 2020 Kenneth McDonald. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// This class is for the login function of the app.
class LoginViewController: UIViewController {
    
    // Variables for email and password fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // Function for when the controller loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allows for the keyboard to hide when the user taps outside of the text field.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        view.addGestureRecognizer(tap)
    }
    
    // Function for logging into the app and firebase.
    @IBAction func loginAction(_ sender: AnyObject) {
        
        // Presents an error due to invalid input in email and/or password text fields.
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
                
                let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)            
                
                self.present(alertController, animated: true, completion: nil)
            
        }
        else {
                // Attempts to log the user into firebase.
                Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                    
                    // If the login is successful, you are directed to main screen
                    if error == nil {
                        
                        self.performSegue(withIdentifier: "entry", sender: nil)
                        
                    }
                    // If login is not successful an error is presented.
                    else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
    }
}
