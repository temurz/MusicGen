//
//  LoginNavigator.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/14/20.
//  Copyright © 2020 Tuan Truong. All rights reserved.
//
import UIKit

protocol LoginNavigatorType {
    func showMain(page: MainPage)
}

struct LoginNavigator: LoginNavigatorType, ShowingMain {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
}
