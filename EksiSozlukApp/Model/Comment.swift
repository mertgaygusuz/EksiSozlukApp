//
//  Comment.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 5.10.2022.
//

import Foundation
import Firebase

class Comment {
    
    private(set) var userName : String!
    private(set) var dateOfUpload : Date!
    private(set) var commentText : String!
    private(set) var documentId : String!
    private(set) var userId : String!
    
    init(userName: String, dateOfUpload: Date, commentText: String, documentId: String, userId: String) {
        self.userName = userName
        self.dateOfUpload = dateOfUpload
        self.commentText = commentText
        self.documentId = documentId
        self.userId = userId
    }
    
    class func fetchComments(snapshot: QuerySnapshot?) -> [Comment] {
        
        var comments = [Comment]()
        
        guard let snap = snapshot else { return comments }
        
        for record in snap.documents {
            
            let data = record.data()
            let userName = data[UserNameRef] as? String ?? "Ziyaretçi"
            let ts = data[DateOfUpload] as? Timestamp ?? Timestamp()
            let dateOfUpload = ts.dateValue()
            let commentText = data[CommentText] as? String ?? "Boş Yorum"
            let documentId = record.documentID
            let userId = data[UserId] as? String ?? ""
            
            let newComment = Comment(userName: userName, dateOfUpload: dateOfUpload, commentText: commentText, documentId: documentId, userId: userId)
            
            comments.append(newComment)
        }
        
        return comments
    }
}
