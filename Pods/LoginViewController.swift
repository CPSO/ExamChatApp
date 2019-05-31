//
//  LoginViewController.swift
//  ExamChatApp
//
//  Created by Tommy Mikkelsen on 14/05/2019.
//  Copyright © 2019 Casper Sillemann. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class LoginViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnCreateUser: UIButton!
    var handle: AuthStateDidChangeListenerHandle?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("state did chanche")
            if let user = user {
                let uid = user.uid
                let uemail = user.email
                print("User Information" + uid + " " + uemail!)
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
}
    
    override func viewWillDisappear(_ animated: Bool) {
        print("removing state listener")
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    @IBAction func btnSignInPressed(_ sender: Any) {
        guard
            let email = textEmail.text,
            let password = textPassword.text,
            email.count > 0,
            password.count > 0
            else {
                print("No Input detected")
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
            if let user = user {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)

            }
    }
    }
    
    
    @IBAction func btnCreateUserPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.textEmail.text!, password: self.textPassword.text!) { (user, error) in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "ERROR",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
}
