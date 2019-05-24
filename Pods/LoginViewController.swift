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
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCreateUser: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnSubmitCalled(_ sender: Any) {
    
        //login(withEmail: textEmail.text!, password: textPassword.text!)
        newLogin()
    }
    
    @IBAction func btnCreatePressed(_ sender: Any) {
        // 1
        let emailField = textEmail.text
        let passwordField = textPassword.text
        // 2
        Auth.auth().createUser(withEmail: emailField!, password: passwordField!) { user, error in
            if error == nil {
                // 3
                Auth.auth().signIn(withEmail: self.textEmail.text!,
                                   password: self.textPassword.text!)
            }
            if error != nil {
                print(error.debugDescription)
                print(error)
            }
        }

        
    }
    
    
    func createUser(email: String, password: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let e = error{
                callback?(e)
                return
            }
            callback?(nil)
        }
    }
    
    func login(withEmail email: String, password: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let e = error{
                callback?(e)
                return
            }
            callback?(nil)

        }
    }
    
    func newLogin() {
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
        }

    }

}
