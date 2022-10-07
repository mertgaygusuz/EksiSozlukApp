//
//  Content.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 1.10.2022.
//

import Foundation
import Firebase
import FirebaseFirestore

class Content {
    
    private(set) var userName : String!
    private(set) var dateOfUpload : Date!
    private(set) var contentText : String!
    private(set) var numberOfComments : Int!
    private(set) var numberOfLikes : Int!
    private(set) var documentId : String!
    private(set) var userId : String!
    
    init(userName: String, dateOfUpload: Date, contentText: String, numberOfComments: Int, numberOfLikes: Int, documentId: String, userId: String) {
        self.userName = userName
        self.dateOfUpload = dateOfUpload
        self.contentText = contentText
        self.numberOfComments = numberOfComments
        self.numberOfLikes = numberOfLikes
        self.documentId = documentId
        self.userId = userId
    }
    
    class func fetchContent(snapshot : QuerySnapshot?) -> [Content] {
        
        var contents = [Content]()
        
        guard let snap = snapshot else { return contents}
        for document in snap.documents {
            
            let data = document.data()
            
            let userName = data[UserName] as? String ?? "Ziyaretçi"
            let ts = data[DateOfUpload] as? Timestamp ?? Timestamp()
            let dateOfUpload = ts.dateValue()
            let contentText = data[ContentText] as? String ?? ""
            let numberOfComments = data[NumberOfComments] as? Int ?? 0
            let numberOfLikes = data[NumberOfLikes] as? Int ?? 0
            let documentId = document.documentID
            let userId = data[UserId] as? String ?? ""
            
            let newContent = Content(userName: userName, dateOfUpload: dateOfUpload, contentText: contentText, numberOfComments: numberOfComments, numberOfLikes: numberOfLikes, documentId: documentId, userId: userId)
            contents.append(newContent)
        }
        return contents
    }
}
