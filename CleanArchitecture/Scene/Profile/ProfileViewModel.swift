//
//  ProfileViewModel.swift
//  CleanArchitecture
//
//  Created by Temur on 11/06/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseAuth
struct ProfileViewModel {
    let navigator: ProfileViewNavigatorType
}

extension ProfileViewModel: ViewModel {
    struct Input {
        let selectRowTrigger: Driver<Int>
    }
    
    final class Output: ObservableObject {
        @Published var change = ""
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.selectRowTrigger
            .sink { id in
                switch id {
                case 0:
                    navigator.showLogin()
                case 4:
                    do {
                        try Auth.auth().signOut()
                        output.change = ""
                        UserDefaults.standard.setValue(nil, forKey: "name")
                        UserDefaults.standard.setValue(nil, forKey: "familyName")
                        UserDefaults.standard.setValue(nil, forKey: "email")
                        UserDefaults.standard.setValue(nil, forKey: "userID")
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                default:
                    break
                }
                
            }
            .store(in: cancelBag)
        
        return output
    }
}
