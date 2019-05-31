//
//  ThirdViewController.swift
//  ExamChatApp
//
//  Created by Tommy Mikkelsen on 31/05/2019.
//  Copyright © 2019 Casper Sillemann. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ThirdViewController: UIViewController {
    let user = Auth.auth().currentUser!
    
    @IBOutlet weak var lableUEmail: UILabel!
    
    @IBOutlet weak var barBtnLogout: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabels()
        
    }
    
    func setLabels() {
        var userEmail = user.email
        lableUEmail.text = user.email
    }
    
    @IBAction func barBtnLogoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
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

}
