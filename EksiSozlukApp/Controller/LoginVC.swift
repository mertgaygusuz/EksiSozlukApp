//
//  LoginVC.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 3.10.2022.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    


    @IBOutlet weak var txtEmailAdress: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        btnLogin.layer.cornerRadius = 10
        btnRegister.layer.cornerRadius = 10
        
    }
    
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        
        guard let emailAdress = txtEmailAdress.text,
              let password = txtPassword.text else { return }
        
        Auth.auth().signIn(withEmail: emailAdress, password: password) { (user, error) in
            
            if let error = error {
                debugPrint("Oturum açılamadı: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    

}
