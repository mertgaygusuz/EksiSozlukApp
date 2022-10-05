//
//  CommentsVC.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 4.10.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class CommentsVC: UIViewController {

    var selectedContent : Content!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtComment: UITextField!
    
    var comments = [Comment]()
    var contentRef : DocumentReference!
    let fireStore = Firestore.firestore()
    var userName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        contentRef = fireStore.collection(Contents).document(selectedContent.documentId)
        
        if let name = Auth.auth().currentUser?.displayName {
            userName = name
        }
    }
    

    @IBAction func btnAddCommentPressed(_ sender: Any) {
        
        guard let commentText = txtComment.text else { return }
        
        fireStore.runTransaction({ (transection, error) -> Any? in
            
            let selectedContentRecord : DocumentSnapshot
            do {
                try selectedContentRecord = transection.getDocument(self.fireStore.collection(Contents).document(self.selectedContent.documentId))
                
            } catch let error as NSError{
                debugPrint("Hata meydana geldi: \(error.localizedDescription)")
                return nil
            }
            
            guard let numberOfOldComments = (selectedContentRecord.data()?[NumberOfComments] as? Int) else { return nil }
            
            transection.updateData([NumberOfComments : numberOfOldComments + 1], forDocument: self.contentRef)
            
            let newCommentRef = self.fireStore.collection(Contents).document(self.selectedContent.documentId)
                .collection(Comments).document()
            transection.setData([
                CommentText : commentText,
                DateOfUpload : FieldValue.serverTimestamp(),
                UserName : self.userName
            ], forDocument: newCommentRef)
            
            return nil
        }) { (object, error) in
            
            if let error = error {
                debugPrint("Hata meydana geldi: \(error.localizedDescription)")
            } else {
                self.txtComment.text = ""
            }
        }
    }
    

}

extension CommentsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell {
            cell.setView(comment: comments[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
