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
    var notebook = [Notebook]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddBook: UIBarButtonItem!
    
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        getData()
        getSharedList()
        checkForRepeats(array: notebook)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("calling viewWillApper")
        checkForUpdates()
        getSharedList()
        checkForRepeats(array: notebook)

    }
    
    func checkForUpdates() {
        db.collection("notebook").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error adding snapshot listener \(error!.localizedDescription)")
                return
            }
            self.getData()
            print("setting new data")
        }
    }
  
    
    
    
    func getData(){
        //let notebookRef = db.collection("notebook")
        //let query = notebookRef.whereField("owner", isEqualTo: "<#T##Any#>")
        db.collection("notebook").whereField("owner", isEqualTo: user?.email!).getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: reading documents \(error!.localizedDescription)")
                return
            }; if querySnapshot!.isEmpty {
                print("User has no own list")
            } else {
                print("getData found docss")
                self.notebook = []
                for document in querySnapshot!.documents {
                    let notebookData = Notebook(dictionary: document.data())
                    notebookData.name = document.get("name") as! String
                    notebookData.id = document.documentID
                    self.notebook.append(notebookData)
                }
            }
        
            self.tableView.reloadData()
        }
       

    }
    
    func getSharedList() {
        db.collection("users").document(user!.uid).collection("sharedList").getDocuments { (QuerySnapshot, err) in
            for document in QuerySnapshot!.documents {
                print("Get Shared list running, Gives:")
                print("printing id for list: ")
                print(document.get("idForList")!)
                self.getNotebooks(docId: document.get("idForList") as! String)
            }
        }
    }
    func getNotebooks(docId: String) {
        db.collection("notebook").document(docId).getDocument { (documentSnapshot, error) in
            if documentSnapshot!.exists{
                print("printing information")
                print(documentSnapshot?.documentID)
                print(documentSnapshot?.get("name"))
                
                let notebookData = Notebook(dictionary: documentSnapshot!.data()!)
                notebookData.name = documentSnapshot!.get("name") as! String
                notebookData.id = documentSnapshot!.documentID
                self.notebook.append(notebookData)
            }
            self.tableView.reloadData()

        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func checkForRepeats(array: [Notebook]) {
        if array.count > 1 {
            for index in 0..<array.count-1 {
                if array[index].name == array[array.count-1].name {
                    showAlert(title: "Two Identical Items Added", message: "\(array[index].name) has been added twice.")
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell.textLabel?.text = notebook[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: " + notebook[indexPath.row].id)
        groceryListId = notebook[indexPath.row].id
        self.tabBarController?.selectedIndex = 1
        
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
        let notebook = Notebook(name: bookname, owner: (user?.email)!, id: "")
        let notebookRef = self.db.collection("notebook")
        notebookRef.document().setData(notebook.dictionary){ err in
            if err != nil {
                print("issue here")
            }else{
                print("Document was saved")
            }
        }
        
    }
    
    // MARK: - Navigation
}


