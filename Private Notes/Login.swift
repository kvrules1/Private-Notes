//
//  Login.swift
//  Private Notes
//
//  Created by KV on 9/27/20.
//  Copyright © 2020 Kenneth McDonald. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class Login: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword:UITextField!

    @IBAction func btnSignupClicked(_ sender: UIButton) {
        //for signup new user
        if ((txtEmail.text ? .isEmpty) ! || (txtPassword.text ? .isEmpty) !) {
            self.showAlert(message: "All fields are mandatory!")
            return
        }
        else {
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) {
                (authResult, error) in
                // ...
                if ((error == nil)) {
                    self.showAlert(message: "Signup Successfully!")
                }
                else {
                    self.showAlert(message: (error ? .localizedDescription) !)
                }
            }
        }
    }
}
