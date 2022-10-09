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
    var commentsListener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        contentRef = fireStore.collection(Contents).document(selectedContent.documentId)
        
        if let name = Auth.auth().currentUser?.displayName {
            userName = name
        }
        
        self.view.setKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        commentsListener = fireStore.collection(Contents).document(selectedContent.documentId).collection(Comments)
            .order(by: DateOfUpload, descending: false)
            .addSnapshotListener({ (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    debugPrint("Yorumlar Listelenemedi: \(error?.localizedDescription)")
                    return
                }
                
                self.comments.removeAll()
                self.comments = Comment.fetchComments(snapshot: snapshot)
                self.tableView.reloadData()
            })
    }

    @IBAction func btnAddCommentPressed(_ sender: Any) {
        
        guard let commentText = txtComment.text, txtComment.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != true
        else { return }
        
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
                UserName : self.userName,
                UserId : Auth.auth().currentUser?.uid ?? ""
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditCommentSegue" {
            
            if let targetVC = segue.destination as? EditCommentVC {
                
                if let commentData = sender as? (selectedComment: Comment, selectedContent: Content) {
                    
                    targetVC.commentData = commentData
                }
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
            cell.setView(comment: comments[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}

extension CommentsVC : CommentDelegate {
    
    func optionsCommentPressed(comment: Comment) {
      
        let alert = UIAlertController(title: "Düzenle", message: "Yorumu Düzenle veya Sil", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Sil", style: .default) { (action) in
            
            self.fireStore.runTransaction({ (transection, error) -> Any? in
                
                let selectedContentRecord : DocumentSnapshot
                
                do  {
                    try selectedContentRecord = transection.getDocument(self.fireStore.collection(Contents).document(self.selectedContent.documentId))
                    
                } catch let error as NSError{
                    debugPrint("Başlık bulunamadı : \(error.localizedDescription)")
                    return nil
                }
                
                guard let numberOfOldComments = (selectedContentRecord.data()?[NumberOfComments] as? Int) else { return nil }
                transection.updateData([NumberOfComments : numberOfOldComments - 1], forDocument: self.contentRef)
                
                let deletedCommentRef = self.fireStore.collection(Contents).document(self.selectedContent.documentId).collection(Comments).document(comment.documentId)
                transection.deleteDocument(deletedCommentRef)
                return nil
                
            }) { (object, error) in
                
                if let error = error {
                    debugPrint("Yorum silinemedi: \(error.localizedDescription)")
                } else {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        let editAction = UIAlertAction(title: "Düzenle", style: .default) { (action) in
            
            self.performSegue(withIdentifier: "EditCommentSegue", sender: (comment, self.selectedContent))
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
