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
    var isDeleted = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        print("calling viewDidLoad")
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidApper")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("calling viewWillApper")
        //getData()
        checkForUpdates()
        getSharedList()
        checkForRepeats(array: notebook)

    }
    
    
    
    func checkForUpdates() {
        print("CheckForUpdates Called")
        db.collection("notebook").whereField("owner", isEqualTo: user?.email!).addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error adding snapshot listener \(error!.localizedDescription)")
                return
            }
            self.notebook = []
            for document in querySnapshot!.documents {
                let notebookData = Notebook(dictionary: document.data())
                notebookData.name = document.get("name") as! String
                notebookData.id = document.documentID
                self.notebook.append(notebookData)
                self.checkForRepeats(array: self.notebook)
            }
            print("setting new data")
            self.tableView.reloadData()
        }
    }
    
    func getSharedList() {
        db.collection("users").document(user!.uid).collection("sharedList").addSnapshotListener { (querySnapshot, error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                for document in querySnapshot!.documents {
                    print("Get Shared list running, Gives:")
                    print("printing id for list: ")
                    print(document.get("idForList")!)
                    self.getNotebooks(docId: document.get("idForList") as! String)
                }
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
    
    func deleteData(index: Int) {
        var isDeleted = false
        
        let ref = db.collection("notebook").document(notebook[index].id)
        ref.getDocument { (docSnap, error) in
            if (self.notebook[index].owner != self.user?.email) {
                print("cant delete other users notebook")
                self.showAlert(title: "Delete Error", message: "Cannot delete other users notebook")
            } else {
                 ref.delete()
                self.getSharedList()
                isDeleted = true
            }
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
                    //showAlert(title: "Two Identical Items Added", message: "\(array[index].name) has been added twice.")
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
        if (notebook[indexPath.row].owner != user?.email){
            cell.contentView.backgroundColor = UIColor.yellow
        } else {
            cell.contentView.backgroundColor = UIColor.green

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteData(index: indexPath.row)
            if (isDeleted){
                tableView.deleteRows(at: [indexPath], with: .fade)
                notebook.remove(at: indexPath.row)
                self.getSharedList()
                
            } else {
                print("not deleteing")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: " + notebook[indexPath.row].id)
        groceryListId = notebook[indexPath.row].id
        print(indexPath.row
        )
        self.tabBarController?.selectedIndex = 1
        
    }
    
    
    @IBAction func btnAddBookPressed(_ sender: Any) {
        let ac = UIAlertController(title: "Enter name for new list", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak ac] _ in
            let answer = ac?.textFields![0]
            self.addBook(bookname: answer!.text!)
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
                self.getSharedList()
            }
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Navigation
}


