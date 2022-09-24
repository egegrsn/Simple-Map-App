//
//  Search+CoreDataProperties.swift
//  SimpleMapApp
//
//  Created by Ege Girsen on 24.09.2022.
//
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var latitude: String
    @NSManaged public var longitude: String
    @NSManaged public var searchText: String?

}

extension Search : Identifiable {

}
