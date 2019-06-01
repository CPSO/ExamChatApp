//
//  NotebookModel.swift
//  ExamChatApp
//
//  Created by Tommy Mikkelsen on 31/05/2019.
//  Copyright © 2019 Casper Sillemann. All rights reserved.
//

import Foundation
class Notebook{
    var name: String = ""
    var owner: String = ""
    var id: String = ""
    
    var dictionary: [String: Any] {
        return ["name": name, "owner": owner,"id": id] }
    
    init(name: String, owner: String, id: String) {
        self.name = name
        self.owner = owner
        self.id = id
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let owner = dictionary["owner"] as! String? ?? ""
        let id = dictionary["id"] as! String? ?? ""
        self.init(name: name, owner: owner, id: id)
    }
    
    
}
    

