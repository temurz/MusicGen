//
//  Row+CoreDataProperties.swift
//  CleanArchitecture
//
//  Created by Temur on 11/06/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//
//

import Foundation
import CoreData


extension Row {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Row> {
        return NSFetchRequest<Row>(entityName: "Row")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var prompt: String?

}

extension Row : Identifiable {

}
