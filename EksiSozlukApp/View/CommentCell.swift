//
//  CommentCell.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 5.10.2022.
//

import UIKit
import FirebaseAuth

class CommentCell: UITableViewCell {
    
    
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var imgOptions: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var delegate : CommentDelegate?
    var selectedComment : Comment!
    
    func setView(comment : Comment, delegate : CommentDelegate){
        
        lblUserName.text = comment.userName
        lblComment.text = comment.commentText
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MM.YYYY, hh:mm"
        let dateOfUpload = dateFormat.string(from: comment.dateOfUpload)
        lblDate.text = dateOfUpload
        
        selectedComment = comment
        self.delegate = delegate
        imgOptions.isHidden = true
        
        if comment.userId == Auth.auth().currentUser?.uid {
            imgOptions.isHidden = false
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(imgCommentOptionsPressed))
            imgOptions.isUserInteractionEnabled = true
            imgOptions.addGestureRecognizer(tap)
        }
    }

    @objc func imgCommentOptionsPressed() {
        delegate?.optionsCommentPressed(comment: selectedComment)
    }
   
}

protocol CommentDelegate {
    func optionsCommentPressed(comment : Comment)
}
