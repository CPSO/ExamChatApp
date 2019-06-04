//
//  PopuoViewController.swift
//  ExamChatApp
//
//  Created by Tommy Mikkelsen on 04/06/2019.
//  Copyright © 2019 Casper Sillemann. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseUI

class PopuoViewController: UIViewController {
    var groceryListId = " "
    var parentVC:SecondViewController?
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        print(groceryListId)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSharePressed(_ sender: Any) {
        print("Share Pressed")
        checkUserEmail()
        
    }
    
    func checkUserEmail() {
        guard
            let email = textEmail.text,
            email.count > 0
            else {
                print("No Input detected")
                return
        }
         let collectionRef = db.collection("users")
        collectionRef.whereField("username", isEqualTo: email).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents" + error.localizedDescription)
            } else if (snapshot?.isEmpty)! {
                print("no users found")
            } else  {
                print("user found")
                for document in (snapshot?.documents)!{
                    self.shareWithUser(email: email, userid: document.documentID)
                }
                }
            }
        }
    
    func shareWithUser(email: String, userid: String) {
        let batch = db.batch()
        
        let sharedUserRef = db.collection("users").document(userid).collection("sharedList").document()
        batch.setData(["idForList": groceryListId,
                       "sharedFromUser": user?.email], forDocument: sharedUserRef)
        
        let sharedListRef = db.collection("notebook").document(groceryListId).collection("sharedWith").document()
        batch.setData(["idForUser": userid], forDocument: sharedListRef)
        
        batch.commit() { err in
            if let err = err {
                print("Error with Batch " + err.localizedDescription)
            } else {
                print("Batch was good")
            }
            
        }
        
        
        
    }
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



