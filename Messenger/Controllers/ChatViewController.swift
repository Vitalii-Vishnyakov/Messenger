//
//  ChatViewController.swift
//  Messenger
//
//  Created by Виталий on 04.03.2022.
//

import UIKit
import MessageKit

struct Message: MessageType{
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    var kind: MessageKind
    
}

struct Sender : SenderType{
    var senderId: String
    var displayName: String
    var photoURL : String
}

class ChatViewController: MessagesViewController{
    
    private var messages =   [Message]()
    private let selfSender = Sender(senderId: "1", displayName: "Bar Boo", photoURL: "")
    override func viewDidLoad() {
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date( ), kind: .text("Hi")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date( ), kind: .text("Hiiiiiiii")))
       
        
        super.viewDidLoad()
        view.backgroundColor = .red
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }

}

extension ChatViewController : MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
