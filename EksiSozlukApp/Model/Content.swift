//
//  Content.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 1.10.2022.
//

import Foundation

class Content {
    
    private(set) var userName : String!
    private(set) var dateOfUpload : Date!
    private(set) var contentText : String!
    private(set) var numberOfComments : Int!
    private(set) var numberOfLikes : Int!
    private(set) var documentId : String!
    
    init(userName: String, dateOfUpload: Date, contentText: String, numberOfComments: Int, numberOfLikes: Int, documentId: String) {
        self.userName = userName
        self.dateOfUpload = dateOfUpload
        self.contentText = contentText
        self.numberOfComments = numberOfComments
        self.numberOfLikes = numberOfLikes
        self.documentId = documentId
    }
}
