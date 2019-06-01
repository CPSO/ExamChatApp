//
//  FirstViewController.swift
//  ExamChatApp
//
//  Created by Tommy Mikkelsen on 31/05/2019.
//  Copyright © 2019 Casper Sillemann. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseUI


class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnAddBook: UIBarButtonItem!
    
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
        // Do any additional setup after loading the view.
    }
    
    
    
    func getDate(){
        let collection = Firestore.firestore().collection(user!.uid)
        db.collection("groceryItem").getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: reading documents \(error!.localizedDescription)")
                return
            }
            self.groceryItem = []
            for document in querySnapshot!.documents {
                let groceryData = GroceryItem(dictionary: document.data())
                groceryData.groceryItemID = document.documentID
                self.groceryItem.append(groceryData)
            }
            if self.sortSegmentedControl.selectedSegmentIndex != 0 {
                self.sortBasedOnSegmentPressed()
            }
            self.tableView.reloadData()
        }
       

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        //let stuff = fR.notes[indexPath.row]
        
        cell.textLabel?.text = "stuff.text"
        
        
        
        //        for note in fR.notes{
        //            cell.textLabel?.text = note.text
        //
        //        }
        // var tableContent =
        
        //        cell.textLabel?.text = String(global.notes[indexPath.row].prefix(50))
        // Configure the cell...
        
        //cell.textLabel?.text = fR.notesCollection.document().
        
        return cell
        
    }
    
    
    @IBAction func btnAddBookPressed(_ sender: Any) {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            self.addBook(bookname: answer.text!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }

    func addBook(bookname:String){
        let notebook = Notebook(name: bookname, owner: (user?.email)!)
        let notebookRef = self.db.collection("notebook")
        
        notebookRef.document().setData(notebook.dictionary){ err in
            if err != nil {
                print("issue here")
            }else{
                print("Document was saved")
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
}


