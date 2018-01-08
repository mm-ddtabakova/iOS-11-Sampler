//
//  CoreDataHandler.swift
//  PersistentHistoryTrackingSample
//
//  Created by Nikolay Andonov on 7.01.18.
//  Copyright © 2018 mentormate. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHandler {
    
    static func insertArticleEntity(name: String) {
        let context = CoreDataManager.sharedInstance.viewContex
        context.performAndWait {
        let articleEntity = Article(context: context)
        articleEntity.name = name
        articleEntity.createdAt = NSDate()
        CoreDataManager.sharedInstance.saveContext(context)
        }
    }

    static func getArticlesFetchedResultsController() -> NSFetchedResultsController<Article> {
        
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.viewContex, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
}
