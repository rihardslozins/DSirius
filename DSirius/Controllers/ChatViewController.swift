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
        
        //Hides back button
        navigationItem.hidesBackButton = true
        addNavBarImage()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
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
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in

            //Empties the messages
            self.messages = []
            
            if let err = error {
                print("There was an issue retrieving data From Firestore. \(err)")
            }else{
                if let snapshotDocuments =  querySnapshot?.documents {
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label?.text = messages[indexPath.row].body
        return cell
    }
}
