//
//  ChatViewController.swift
//  DSirius
//
//  Created by Rihards Lozins on 22/02/2021.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey!"),
        Message(sender: "a@b.com", body: "Hello!"),
        Message(sender: "1@2.com", body: "Whats up?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hides back button
        navigationItem.hidesBackButton = true
        addNavBarImage()

        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    
    func addNavBarImage() {
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Dsirius_Logo"))
        imageView.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        imageView.contentMode = .scaleAspectFit
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 30))
        
        titleView.addSubview(imageView)
        titleView.backgroundColor = .clear
        self.navigationItem.titleView = titleView
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        
    }
    
    @IBAction func logoOutPressed(_ sender: UIBarButtonItem) {
        
        
        do {
            try Auth.auth().signOut()
            
            //Navigates to start screen when Log Out is pressed
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.label?.text = messages[indexPath.row].body
        return cell
    }
}
