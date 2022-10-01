//
//  AddContentVC.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 29.09.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddContentVC: UIViewController {
    
    
    
    @IBOutlet weak var segmentCategories: UISegmentedControl!
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtContent: UITextView!
    
    @IBOutlet weak var btnShared: UIButton!
    
    let placeholderText = "Fikrinizi belirtin..."
    var selectedCategory = "Eğlence"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnShared.layer.cornerRadius = 5
        txtContent.layer.cornerRadius = 7
        
        txtContent.text = placeholderText
        txtContent.textColor = .lightGray
        txtContent.delegate = self
    }
    

    @IBAction func segmentCategoryChanged(_ sender: Any) {
        
        switch segmentCategories.selectedSegmentIndex {
            case 0 :
                selectedCategory = Categories.Eglence.rawValue
            case 1 :
                selectedCategory = Categories.Gundem.rawValue
            case 2 :
                selectedCategory = Categories.Spor.rawValue
            case 3 :
                selectedCategory = Categories.Populer.rawValue
            default :
                selectedCategory = Categories.Eglence.rawValue
        }
    }
    
    @IBAction func btnSharedPressed(_ sender: Any) {
        
        guard let userName = txtUserName.text else { return }
        
        Firestore.firestore().collection(Contents).addDocument(data: [
            Category : selectedCategory,
            NumberOfLikes : 0,
            NumberOfComments : 0,
            ContentText : txtContent.text,
            DateOfUpload : FieldValue.serverTimestamp(),
            UserName : txtUserName.text
        ]) { (error) in
            
            if let error = error {
                print("Document Hatası: \(error.localizedDescription)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
        
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
