//
//  MainAssembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/14/20.
//  Copyright © 2020 Tuan Truong. All rights reserved.
//

import UIKit

protocol MainAssembler {
    func resolve(navigationController: UINavigationController, page: MainPage) -> MainView
    func resolve(navigationController: UINavigationController, page: MainPage) -> MainViewRouter
    func resolve(navigationController: UINavigationController) -> MainViewModel
    func resolve(navigationController: UINavigationController) -> MainNavigatorType
    func resolve() -> MainUseCaseType
}

extension MainAssembler {
    
    func resolve(navigationController: UINavigationController, page: MainPage = .home) -> MainView {
        let view = MainView(viewRouter: resolve(navigationController: navigationController, page: page))
//        let vm: MainViewModel = resolve(navigationController: navigationController)
//        vc.bindViewModel(to: vm)
        return view
    }
    
    func resolve(navigationController: UINavigationController) -> MainViewModel {
        return MainViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension MainAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController, page: MainPage = .home) -> MainViewRouter {
        let router = MainViewRouter(assembler: self, navigationController: navigationController, page: page)
        return router
    }
    
    func resolve(navigationController: UINavigationController) -> MainNavigatorType {
        return MainNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> MainUseCaseType {
        return MainUseCase()
    }
}

extension MainAssembler where Self: PreviewAssembler {
    func resolve(navigationController: UINavigationController, page: MainPage = .home) -> MainViewRouter {
        let router = MainViewRouter(assembler: self, navigationController: navigationController, page: page)
        return router
    }
    
    func resolve(navigationController: UINavigationController) -> MainNavigatorType {
        return MainNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> MainUseCaseType {
        return MainUseCase()
    }
}
