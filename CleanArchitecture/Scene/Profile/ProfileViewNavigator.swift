//
//  ProfileViewNavigator.swift
//  CleanArchitecture
//
//  Created by Temur on 11/06/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import Foundation
import UIKit
protocol ProfileViewNavigatorType {
    func showLogin()
}

struct ProfileViewNavigator: ProfileViewNavigatorType, ShowingLogin {
    var assembler: Assembler
    
    var navigationController: UINavigationController
    
    
}
