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

    }
    
    @IBAction func btnSharePressed(_ sender: Any) {
        print("Share Pressed")
        checkUserEmail()
        self.removeFromParent()
        
        
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
        
        let sharedUserRef = db.collection("users").document(userid).collection("sharedList").whereField("idForList", isEqualTo: groceryListId)
        sharedUserRef.getDocuments { (snap, error) in
            if snap!.isEmpty{
                self.db.collection("users").document(userid).collection("sharedList").addDocument(data: ["idForList" : self.groceryListId, "sharedFromUser": self.user?.email])
                
                let sharedListRef = self.db.collection("notebook").document(self.groceryListId).collection("sharedWith").document()
                batch.setData(["idForUser": userid], forDocument: sharedListRef)
                
                batch.commit() { err in
                    if let err = err {
                        print("Error with Batch " + err.localizedDescription)
                    } else {
                        print("Batch was good")
                        self.parentVC?.dismiss(animated: true, completion: nil)

                    }
                    
                }
                
            } else {
                print("user already on list!")
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



