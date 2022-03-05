//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Виталий on 03.03.2022.
//

import Foundation
import FirebaseDatabase
import RealmSwift

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = FirebaseDatabase.Database.database(url: "https://messenger-6b239-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    
    static func safeEmail( email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "^")
        return safeEmail
    }
}
//MARK: - Account manager
extension DatabaseManager {
    
    public func  userExists ( with email : String, complition : @escaping ((Bool) -> Void))  {
        
        
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
    public func getAllUsers(completion: @escaping (Result<[[String: String]],Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseErrors.FaildToFetch))
                return
            }
            completion(.success(value))
        }
    }
    
    /// insert new user to database
    public func insertUser (with user : ChatAppUser ,completion : @escaping (Bool) -> Void){
        
        
        database.child(user.safeEmail).setValue(["firstName" : user.firstName, "lastName" : user.lastName]) { error, _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                if var usersCollection = snapshot.value as? [ [String:String]]{
                    let newElement = ["name": user.firstName + " " + user.lastName, "email" : user.safeEmail]
                    usersCollection.append(newElement)
                    self.database.child("users").setValue(usersCollection) { error, _ in
                        
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                    
                    
                }
                else{
                    let newCollection : [[String: String]] = [["name": user.firstName + " " + user.lastName, "email" : user.safeEmail]]
                    self.database.child("users").setValue(newCollection) { error, _ in
                        
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                }
            }
            completion(true)
        }
        
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
    var profilePicture : String {
        return "\(safeEmail)_profile_picture.png"
    }
    
}
enum DatabaseErrors: Error {
    case FaildToFetch
}
