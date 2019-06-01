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
        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("calling viewWillApper")
        getData()
        checkForUpdates()
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
            }
            self.notebook = []
            for document in querySnapshot!.documents {
                let notebookData = Notebook(dictionary: document.data())
                notebookData.name = document.get("name") as! String
                notebookData.id = document.documentID
                self.notebook.append(notebookData)
            }
            self.tableView.reloadData()
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


