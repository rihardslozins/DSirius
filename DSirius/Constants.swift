//
//  Constants.swift
//  DSirius
//
//  Created by Rihards Lozins on 23/02/2021.
//

struct MainC {
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct Colors {
        
        static let bubbleBlue = "BrandBlueBubble"
        static let bubbleRed = "BrandRedBubble"
        
    }
    
    struct FStore {
        
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
