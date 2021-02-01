//
//  DatabaseManager.swift
//  Instagram
//
//  Created by Ilham Huda on 22/01/21.
//

import UIKit
import FirebaseDatabase

public class DatabaseManager: UIViewController {
  
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    // MARK: - Public
    public  func canCreateNewUser(with email:String, username:String, Completion: (Bool)-> Void) {
        Completion(true)
    }
    
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        let key = email.safeDatabaseKey()
        print(key)
        
        database.child(key).setValue(["username":username]) { error, _ in
            if error == nil {
                completion(true)
                return
            }
            else {
                completion(false)
                return
            }
            
        }
        
        
    }
    
    //MARK: - Private
    
    
    
    
    
    
}
