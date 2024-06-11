//
//  ApplicationUtility.swift
//  CleanArchitecture
//
//  Created by Temur on 10/06/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import UIKit
final class ApplicationUtility {
    static var rootViewController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
