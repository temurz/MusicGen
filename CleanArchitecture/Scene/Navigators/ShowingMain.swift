//
//  ShowingMain.swift
//  CleanArchitecture
//
//  Created by Temur on 11/06/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import UIKit
import SwiftUI
protocol ShowingMain {
    var assembler: Assembler { get }
    var navigationController: UINavigationController { get }
}

extension ShowingMain {
    func showMain(page: MainPage) {
        let view: MainView = assembler.resolve(navigationController: navigationController, page: page)
        
        let vc = UIHostingController(rootView: view)
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.setViewControllers([vc], animated: true)
    }
}
