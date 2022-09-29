//
//  AddContentVC.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 29.09.2022.
//

import UIKit

class AddContentVC: UIViewController {
    
    
    
    @IBOutlet weak var segmentCategories: UISegmentedControl!
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtContent: UITextView!
    
    @IBOutlet weak var btnShared: UIButton!
    
    let placeholderText = "Fikrinizi belirtin..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnShared.layer.cornerRadius = 5
        txtContent.layer.cornerRadius = 7
        
        txtContent.text = placeholderText
        txtContent.textColor = .lightGray
        txtContent.delegate = self
    }
    

    @IBAction func segmentCategoryChanged(_ sender: Any) {
        
    }
    
    @IBAction func btnSharedPressed(_ sender: Any) {
        
    }
    
}

extension AddContentVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtContent.text == placeholderText {
            textView.text = ""
            textView.textColor = .darkGray
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            txtContent.text = placeholderText
            txtContent.textColor = .lightGray
        }
        
    }
}
