//
//  ListItem+CoreDataProperties.swift
//  Timestamp
//
//  Created by Alima Zhaksylyk on 20.07.2023.
//
//

import Foundation
import CoreData


extension ListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListItem> {
        return NSFetchRequest<ListItem>(entityName: "ListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ListItem : Identifiable {

}
