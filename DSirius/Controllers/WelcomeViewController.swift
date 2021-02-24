//
//  WelcomeViewController.swift
//  DSirius
//
//  Created by Rihards Lozins on 22/02/2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //Hides the NavBar in Welcome Screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    //Shows the NavBar in Other Screens
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

}
