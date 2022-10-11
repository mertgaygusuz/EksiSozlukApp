//
//  ContentCell.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 1.10.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ContentCell: UITableViewCell {
    
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblContentText: UILabel!
    @IBOutlet weak var lblDateOfUpload: UILabel!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var lblNumberOfLikes: UILabel!
    @IBOutlet weak var lblNumberOfComments: UILabel!
    @IBOutlet weak var imgOptions: UIImageView!
    
    var selectedContent : Content!
    var delegate : ContentDelegate?
    let fireStore = Firestore.firestore()
    var likes = [Like]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgLikeTapped))
        imgLike.addGestureRecognizer(tap)
        imgLike.isUserInteractionEnabled = true
    }

    func fetchLikes() {
        
        let likeQuery = fireStore.collection(Contents).document(self.selectedContent.documentId).collection(LikeRef)
            .whereField(UserId, isEqualTo: Auth.auth().currentUser?.uid ?? "")
        
        likeQuery.getDocuments { (snapshot, error) in
            self.likes = Like.fetchLikes(snapshot: snapshot)
            
            if self.likes.count > 0 {
                self.imgLike.image = UIImage(named: "selectedStar")
            } else {
                self.imgLike.image = UIImage(named: "transparentStar")
            }
        }
    }
    
    @objc func imgLikeTapped() {
        
        fireStore.runTransaction({ (transaction, errorPointer) -> Any? in
            
            let selectedContentRecord : DocumentSnapshot
            
            do {
                try selectedContentRecord = transaction.getDocument(self.fireStore.collection(Contents).document(self.selectedContent.documentId))
            } catch let error as NSError{
                debugPrint("Beğenilemedi: \(error.localizedDescription)")
                return nil
            }
            
            guard let oldLikes = (selectedContentRecord.data()?[NumberOfLikes] as? Int) else { return nil }
            
            let selectedContentRef = self.fireStore.collection(Contents).document(self.selectedContent.documentId)
            
            if self.likes.count > 0 {
                
                transaction.updateData([NumberOfLikes : oldLikes - 1], forDocument: selectedContentRef)
                let oldLikeRef = self.fireStore.collection(Contents).document(self.selectedContent.documentId).collection(LikeRef).document(self.likes[0].documentId)
                transaction.deleteDocument(oldLikeRef)
            } else {
                
                transaction.updateData([NumberOfLikes : oldLikes + 1], forDocument: selectedContentRef)
                let newLikeRef = self.fireStore.collection(Contents).document(self.selectedContent.documentId).collection(LikeRef).document()
                transaction.setData([UserId : Auth.auth().currentUser?.uid ?? ""], forDocument: newLikeRef)
            }
            
            
            return nil
        }) { (object, error) in
            
            if let error = error {
                debugPrint("Beğenilemedi: \(error.localizedDescription)")
            }
        }
    }
    
    func setView(content: Content, delegate: ContentDelegate?) {
        selectedContent = content
        lblUserName.text = content.userName
        lblContentText.text = content.contentText
        lblNumberOfLikes.text = "\(content.numberOfLikes ?? 0)"
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MM.YYYY, hh:mm"
        let dateOfUpload = dateFormat.string(from: content.dateOfUpload)
        lblDateOfUpload.text = dateOfUpload
        lblNumberOfComments.text = "\(content.numberOfComments ?? 0)"
        
        imgOptions.isHidden = true
        self.delegate = delegate
        
        if content.userId == Auth.auth().currentUser?.uid {
            
            imgOptions.isHidden = false
            imgOptions.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(imgContentOptionsPressed))
            imgOptions.addGestureRecognizer(tap)
        }
        
        fetchLikes()
    }
    
    @objc func imgContentOptionsPressed() {
        delegate?.optionsContentPressed(content: selectedContent)
    }
}

protocol ContentDelegate {
    func optionsContentPressed(content: Content)
}
