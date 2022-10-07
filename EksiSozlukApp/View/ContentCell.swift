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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgLikeTapped))
        imgLike.addGestureRecognizer(tap)
        imgLike.isUserInteractionEnabled = true
    }

    @objc func imgLikeTapped() {
        
        Firestore.firestore().document("Contents/\(selectedContent.documentId!)").updateData(
            [NumberOfLikes : selectedContent.numberOfLikes + 1])
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
    }
    
    @objc func imgContentOptionsPressed() {
        delegate?.optionsContentPressed(content: selectedContent)
    }
}

protocol ContentDelegate {
    func optionsContentPressed(content: Content)
}
