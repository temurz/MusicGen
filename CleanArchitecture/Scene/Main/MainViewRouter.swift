//
//  MainViewRouter.swift
//  AkfaSmart
//
//  Created by Temur on 01/02/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
enum MainPage: String{
    case home
    case catalog
    case settings
}

class MainViewRouter: ViewRouter {
    let navigationController: UINavigationController
    let assembler: Assembler
    
    
    var pages: [TabBarItem] = [TabBarItem(imageName: "music.quarternote.3", title: "Generate", id: MainPage.home.rawValue),
                               TabBarItem(imageName: "square.stack.3d.up", title: "History", id: MainPage.catalog.rawValue),
                               TabBarItem(imageName: "person.crop.circle.fill", title: "Profile", id: MainPage.settings.rawValue)]
    
    @Published var selectedPageId: String = MainPage.home.rawValue
    @Published var body: AnyView
    
    func route(selectedPageId: String) {
        if self.selectedPageId == selectedPageId {
            return
        }
        self.selectedPageId = selectedPageId
        switch selectedPageId {
        case MainPage.home.rawValue:
            let view: ContentView = ContentView()
            body = AnyView(view)
            break
        case MainPage.catalog.rawValue:
            let view: HistoryView = HistoryView()
            
            body = AnyView(view)
            break
        case MainPage.settings.rawValue:
            let view: ProfileView = assembler.resolve(navigationController: navigationController)
            
            body = AnyView(view)
            break
        default:
            body = AnyView(Text("DEFAULT"))
            break
        }
    }
    
    init(assembler: Assembler, navigationController: UINavigationController, page: MainPage = .home){
        self.navigationController  = navigationController
        self.assembler = assembler
//        self.homeView = assembler.resolve(navigationController: navigationController)
        let view: ContentView = ContentView()
        self.body = AnyView(view)
        if page != .home {
            self.route(selectedPageId: page.rawValue)
        }
        self.selectedPageId = page.rawValue
        
    }
    
}
