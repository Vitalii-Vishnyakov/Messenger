//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Виталий on 03.03.2022.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = FirebaseDatabase.Database.database(url: "https://messenger-6b239-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    
    
}
//MARK: - Account manager
extension DatabaseManager {
    
    public func userExists ( with email : String, complition : @escaping ((Bool) -> Void))  {
        
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "^")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapchot in
            guard snapchot.value as? String != nil else {
                complition(false)
                return
            }
            complition(true)
        })
        
    }
    /// insert new user to database
    public func insertUser (with user : ChatAppUser ){
        
     
        database.child(user.safeEmail).setValue(["firstName" : user.firstName, "lastName" : user.lastName])
        
    }
}

struct ChatAppUser{
    let firstName : String
    let lastName : String
    let emailAdress : String
    var safeEmail : String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "^")
        return safeEmail
    }
    
}
