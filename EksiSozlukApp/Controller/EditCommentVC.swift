//
//  EditCommentVC.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 9.10.2022.
//

import UIKit
import Firebase

class EditCommentVC: UIViewController {
    
    
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var btnEdit: UIButton!
    
    var commentData : (selectedComment: Comment, selectedContent: Content)!

    override func viewDidLoad() {
        super.viewDidLoad()

        txtComment.layer.cornerRadius = 10
        btnEdit.layer.cornerRadius = 10
        
        txtComment.text = commentData.selectedComment.commentText!
    }
    

    @IBAction func btnEditPressed(_ sender: Any) {
        
        guard let commentText = txtComment.text, txtComment.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != true
        else { return }
        
        Firestore.firestore().collection(Contents).document(commentData.selectedContent.documentId)
            .collection(Comments).document(commentData.selectedComment.documentId).updateData([CommentText : commentText]) { (error) in
                
                if let error = error {
                    debugPrint("Yorum güncellenemedi: \(error.localizedDescription)")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        
        
    }
    

}
