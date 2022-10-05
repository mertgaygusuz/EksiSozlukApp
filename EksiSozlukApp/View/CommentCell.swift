//
//  CommentCell.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 5.10.2022.
//

import UIKit

class CommentCell: UITableViewCell {
    
    
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblComment: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setView(comment : Comment){
        
        lblUserName.text = comment.userName
        lblComment.text = comment.commentText
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MM.YYYY, hh:mm"
        let dateOfUpload = dateFormat.string(from: comment.dateOfUpload)
        lblDate.text = dateOfUpload
    }

   
}
