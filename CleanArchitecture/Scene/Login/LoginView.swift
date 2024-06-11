//
//  LoginView.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/29/20.
//  Copyright © 2020 Tuan Truong. All rights reserved.
//

import SwiftUI
import Combine
import GoogleSignInSwift
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
struct LoginView: View {
    @ObservedObject var input: LoginViewModel.Input
    @ObservedObject var output: LoginViewModel.Output
    private let cancelBag = CancelBag()
    private let loginTrigger = PassthroughSubject<Void, Never>()
    private let goToMainTrigger = PassthroughSubject<Void, Never>()
    
    var body: some View {
        LoadingView(isShowing: $output.isLoading, text: .constant("")) {
            VStack(alignment: .leading) {
                Text("User name:")
                TextField("", text: self.$input.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(self.output.usernameValidationMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                Text("Password:")
                    .padding(.top)
                SecureField("", text: self.$input.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(self.output.passwordValidationMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                HStack {
                    Spacer()
                    Button("Login") {
                        self.loginTrigger.send(())
                    }
                    .disabled(!self.output.isLoginEnabled)
                    .padding(.top)
                    Spacer()
                }
                HStack {
                    Spacer()
                    GoogleSignInButton(action: signInWithGoogle)
                        .cornerRadius(12)
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $output.alert.isShowing) {
            Alert(
                title: Text(output.alert.title),
                message: Text(output.alert.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationTitle("Profile")
    }
    
    init(viewModel: LoginViewModel) {
        let input = LoginViewModel.Input(loginTrigger: loginTrigger.asDriver(),goToMainTrigger:goToMainTrigger.asDriver())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
    }
    
    private func signInWithGoogle() {
        output.isLoading = true
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController) { user, error in
            if let error {
                print(error.localizedDescription)
                output.isLoading = false
                return
            }
            guard let user = user?.user,
                  let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString)
            UserDefaults.standard.setValue(user.profile?.imageURL(withDimension: 320)?.absoluteString, forKey: "imageURL")
            
            if Auth.auth().currentUser == nil {
                Auth.auth().signIn(with: credential) { res, error in
                    output.isLoading = false
                    if let error {
                        output.isLoading = false
                        print(error.localizedDescription)
                        return
                    }
                    guard let user = res?.user else {return}
                    print(user)
                    goToMainTrigger.send(())
                }
            }else {
                output.isLoading = false
                goToMainTrigger.send(())
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel: LoginViewModel = PreviewAssembler().resolve(navigationController: UINavigationController())
        return LoginView(viewModel: viewModel)
    }
}
