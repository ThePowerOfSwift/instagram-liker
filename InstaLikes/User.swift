//
//  User.swift
//  InstaLikes
//
//  Created by Taras Markevych on 4/4/17.
//  Copyright © 2017 ITChallenge. All rights reserved.
//

import UIKit
import SwiftyJSON

class User {
    
    var firstName = ""
    var lastName = ""
    var userName = ""
    var instagramAccessToken = ""
    var instagramId = ""
    
    init(json: JSON) {
        
        if let accessToken = json["access_token"].string, let userID = json["user"]["id"].string {
            
            self.instagramAccessToken = accessToken
            self.instagramId = userID
            
            let instagramUser = json["user"]
            let fullName = instagramUser["full_name"].stringValue
            var names = fullName.components(separatedBy: " ")
            
            if (names.count > 0) {
                self.firstName = names[0]
            }
            if (names.count > 1) {
                self.lastName = names[1]
            }
            if (names.count > 2) {
                self.lastName = names[names.count-1]
            }
            
            self.userName = instagramUser["username"].stringValue
        }
    }
    
    
}
