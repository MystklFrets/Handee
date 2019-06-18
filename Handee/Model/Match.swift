//
//  Match.swift
//  Handee
//
//  Created by Raul Fernando Gutierrez on 6/15/19.
//  Copyright © 2019 Raul Fernando Gutierrez. All rights reserved.
//

import Foundation

struct Match {
    let name, profileImageUrl, uid: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

