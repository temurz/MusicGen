//
//  UpdateModel.swift
//  CleanArchitecture
//
//  Created by Temur on 12/09/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import Foundation
public struct UpdateOutput: Decodable {
    public let status: String?
    public let output: URL?
}
