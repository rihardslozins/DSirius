//
//  RegisterViewController.swift
//  DSirius
//
//  Created by Rihards Lozins on 22/02/2021.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: Any) {
        
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    //Navigate to the ChatViewController
                    self.performSegue(withIdentifier: "RegisterToChat", sender: self)
                }
            }
        }
    }

}//End
