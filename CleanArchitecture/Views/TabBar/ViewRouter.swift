//
//  ViewRouter.swift
//  AkfaSmart
//
//  Created by Temur on 01/02/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import Foundation
protocol ViewRouter: ObservableObject{
    var selectedPageId: String {get}
    var pages: [TabBarItem] {get}
    func route(selectedPageId: String)
}
