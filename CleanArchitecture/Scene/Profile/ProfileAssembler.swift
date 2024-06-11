//
//  ProfileAssembler.swift
//  CleanArchitecture
//
//  Created by Temur on 11/06/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import UIKit
protocol ProfileAssembler {
    func resolve(navigationController: UINavigationController) -> ProfileView
    func resolve(navigationController: UINavigationController) -> ProfileViewModel
    func resolve(navigationController: UINavigationController) -> ProfileViewNavigatorType
}

extension ProfileAssembler {
    func resolve(navigationController: UINavigationController) -> ProfileView {
        return ProfileView(viewModel: resolve(navigationController: navigationController))
    }
    func resolve(navigationController: UINavigationController) -> ProfileViewModel {
        return ProfileViewModel(navigator: resolve(navigationController: navigationController))
    }
}

extension ProfileAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> ProfileViewNavigatorType {
        return ProfileViewNavigator(assembler: self, navigationController: navigationController)
    }
}

extension ProfileAssembler where Self: PreviewAssembler {
    func resolve(navigationController: UINavigationController) -> ProfileViewNavigatorType {
        return ProfileViewNavigator(assembler: self, navigationController: navigationController)
    }
}
