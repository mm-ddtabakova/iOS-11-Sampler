//
//  Article+CoreDataProperties.swift
//  PersistentHistoryTrackingSample
//
//  Created by Nikolay Andonov on 7.01.18.
//  Copyright © 2018 mentormate. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: NSDate?

}
