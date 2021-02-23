//
//  LoginViewController.swift
//  DSirius
//
//  Created by Rihards Lozins on 22/02/2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    //Navigate to the ChatViewController
                    self.performSegue(withIdentifier: "LoginToChat", sender: self)
                }
            }
        }
    }
}//End
