//
//  CreateUserVC.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 3.10.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CreateUserVC: UIViewController {
    
    
    @IBOutlet weak var txtEmailAdress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnRegister.layer.cornerRadius = 10
        btnBack.layer.cornerRadius = 10
    }
    

    @IBAction func btnRegisterPressed(_ sender: Any) {
        
        guard let emailAdress = txtEmailAdress.text,
              let password = txtPassword.text,
              let userName = txtUserName.text else { return }
        
        Auth.auth().createUser(withEmail: emailAdress, password: password) { (userInformation, error) in
            
            if let error = error {
                debugPrint("Hesap oluşturulamadı: \(error.localizedDescription)")
            }
            
            let changeRequest = userInformation?.user.createProfileChangeRequest()
            changeRequest?.displayName = userName
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    debugPrint("Kullanıcı adı eklenirken hata oluştu: \(error.localizedDescription)")
                }
            })
            
            guard let userId = userInformation?.user.uid else { return }
            
            Firestore.firestore().collection(Users).document(userId).setData([
                UserNameRef : userName,
                UserCreationTime : FieldValue.serverTimestamp()
            ],
            completion: { (error) in
                if let error = error {
                    debugPrint("Kullanıcı eklenirken hata meydana geldi: \(error.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    

    @IBAction func btnBackPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
