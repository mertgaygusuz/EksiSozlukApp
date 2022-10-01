//
//  ContentCell.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 1.10.2022.
//

import UIKit

class ContentCell: UITableViewCell {
    
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblContentText: UILabel!
    @IBOutlet weak var lblDateOfUpload: UILabel!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var lblNumberOfLikes: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setView(content: Content) {
        
        lblUserName.text = content.userName
        lblContentText.text = content.contentText
        lblNumberOfLikes.text = "\(content.numberOfLikes ?? 0)"
    }

}
