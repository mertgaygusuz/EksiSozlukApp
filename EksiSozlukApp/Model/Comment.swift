//
//  Comment.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 5.10.2022.
//

import Foundation

class Comment {
    
    private(set) var userName : String!
    private(set) var dateOfUpload : Date!
    private(set) var commentText : String!
    
    init(userName: String, dateOfUpload: Date, commentText: String) {
        self.userName = userName
        self.dateOfUpload = dateOfUpload
        self.commentText = commentText
    }
}
