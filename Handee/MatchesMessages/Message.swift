//
//  Message.swift
//  Handee
//
//  Created by Raul Fernando Gutierrez on 6/7/19.
//  Copyright © 2019 Raul Fernando Gutierrez. All rights reserved.
//

import Firebase

struct Message {
    let text, fromId, toId: String
    let timestamp: Timestamp
    
    let isFromCurrentLoggedUser: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentLoggedUser = Auth.auth().currentUser?.uid == self.fromId
    }
}
