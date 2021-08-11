//
//  AuthService.swift
//  MyChatApp
//
//  Created by gadgetzone on 11/08/21.
//

import Firebase
import UIKit

struct RegistrationCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}
struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUserIn(credentials: RegistrationCredentials, completion:((Error?) -> Void)?) {
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/Profile_Images/\(fileName)")
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                print("Debug fail to upload image \(error.localizedDescription)")
                return
            }
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Fail To create user with error \(error.localizedDescription)")
                    }
                    guard let uid = result?.user.uid else { return }
                    let data = ["email": credentials.email,
                                "fullname": credentials.fullname,
                                "profileImageUrl":  profileImageUrl,
                                "uid": uid,
                                "username": credentials.username ] as [String: Any ]
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                }
            }
        }

    }
}
