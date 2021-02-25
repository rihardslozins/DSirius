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
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hides back button for ChatViewController
        navigationItem.hidesBackButton = true
        addNavBarImage()
        
        tableView.dataSource = self
        
        //Registers a custom cell that is created (MessageCell)
        tableView.register(UINib(nibName: MainC.cellNibName, bundle: nil), forCellReuseIdentifier: MainC.cellIdentifier)
        
        loadMessages()
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
    
    
    func loadMessages() {
        
        db.collection(MainC.FStore.collectionName)
            .order(by: MainC.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
                //Empties the messages
                self.messages = []
                
                if let err = error {
                    print("There was an issue retrieving data From Firestore. \(err)")
                }else{
                    if let snapshotDocuments =  querySnapshot?.documents {
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            if let messageSender = data[MainC.FStore.senderField] as? String, let messageBody = data[MainC.FStore.bodyField] as? String {
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        
        //Constant that stores the message in textField
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            
            //Stores data in Firestore
            db.collection(MainC.FStore.collectionName).addDocument(data: [
                MainC.FStore.senderField: messageSender,
                MainC.FStore.bodyField: messageBody,
                //
                MainC.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let err = error {
                    print("There was an issue, \(err)")
                }else{
                    print("Successfully saved data")
                }
            }
        }
    }
    
    @IBAction func logoOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            
            //Navigates to start screen when Log Out is pressed
            navigationController?.popToRootViewController(animated: true)
            
            //Catch block will carry out if theres is a problem signing out the user
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
        
        let message = messages[indexPath.row]
        
        //Shows custom cell, that is created
        let cell = tableView.dequeueReusableCell(withIdentifier: MainC.cellIdentifier, for: indexPath) as! MessageCell
        cell.label?.text = message.body
        
        //This is a message from current user
        if message.sender == Auth.auth().currentUser?.email {
            
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: MainC.Colors.bubbleBlue)
            
        }
        //This is a message from other user
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: MainC.Colors.bubbleRed)
        }
        
        return cell
    }
}
