//
//  Service.swift
//  MyChatApp
//
//  Created by gadgetzone on 11/08/21.
//

import Firebase

struct Service {
    static func fetchUsers(complition: @escaping([User]) -> Void ) {
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
                complition(users)
            })
        }
    }
}
