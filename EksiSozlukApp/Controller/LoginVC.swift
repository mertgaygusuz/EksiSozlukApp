//
//  LoginVC.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 3.10.2022.
//

import UIKit

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
    }
    
    
    @IBAction func btnRegisterPressed(_ sender: Any) {
    }
    

    

}
