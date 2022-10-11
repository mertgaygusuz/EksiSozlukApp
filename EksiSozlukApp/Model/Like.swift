//
//  Like.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 11.10.2022.
//

import Foundation
import Firebase

class Like {
    
    private(set) var userId : String
    private(set) var documentId : String
    
    init (userId: String, documentId: String) {
        self.userId = userId
        self.documentId = documentId
    }
    
    class func fetchLikes(snapshot : QuerySnapshot?) -> [Like] {
        
        var likes = [Like]()
        
        guard let snap = snapshot else { return likes }
        
        for record in snap.documents {
            
            let data = record.data()
            let userId = data[UserId] as? String ?? ""
            let documentId = record.documentID
            
            let newLike = Like(userId: userId, documentId: documentId)
            likes.append(newLike)
        }
        return likes
    }
}
