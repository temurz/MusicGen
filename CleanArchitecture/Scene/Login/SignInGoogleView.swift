//
//  SignInGoogleView.swift
//  CleanArchitecture
//
//  Created by Temur on 10/06/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import Foundation
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
class SignInGoogleView: ObservableObject {
    @Published var isLoginSucceeded = false
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController) { user, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            guard let user = user?.user,
                  let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { res, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                guard let user = res?.user else {return}
                UserDefaults.standard.setValue(user.uid, forKey: "userID")
                print(user)
            }
        }
    }
}
