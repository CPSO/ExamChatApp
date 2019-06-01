//
//  NotebookModel.swift
//  ExamChatApp
//
//  Created by Tommy Mikkelsen on 31/05/2019.
//  Copyright © 2019 Casper Sillemann. All rights reserved.
//

import Foundation
class NotebookItem{
    var name: String = ""
    var quantity: Int
    var notes: String = ""
    var postingUserID: String = ""
    
    var dictionary: [String: Any] {
        return ["name": name, "quantity": quantity, "notes": notes, "postingUserID": postingUserID] }
    
    init(name: String, quantity: Int, notes: String, postingUserID: String) {
        self.name = name
        self.quantity = quantity
        self.notes = notes
        self.postingUserID = postingUserID
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let quantity = dictionary["quantity"] as! Int? ?? 1
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let notes = dictionary["notes"] as! String? ?? ""
        self.init(name: name, quantity: quantity, notes: notes, postingUserID: postingUserID)
    }
    
    
}
    

