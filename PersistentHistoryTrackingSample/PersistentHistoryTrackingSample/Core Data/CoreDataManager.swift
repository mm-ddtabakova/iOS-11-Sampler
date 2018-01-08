//
//  CoreDataManager.swift
//  PersistentHistoryTrackingSample
//
//  Created by Nikolay Andonov on 7.01.18.
//  Copyright © 2018 mentormate. All rights reserved.
//

import Foundation
import CoreData

private let sharedCoreDataManager = CoreDataManager()

class CoreDataManager {
    
    class var sharedInstance: CoreDataManager {
        return sharedCoreDataManager
    }
    
    private lazy var persistentContainer: CustomPersistantContainer = {
        let container = CustomPersistantContainer(name: "PersistentHistoryTrackingSampleModel")
        container.enablePersistentHistoryTracking()
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error))")
            }
        })
        return container
    }()
    
    var viewContex: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var newBackgroundContex: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}

class CustomPersistantContainer : NSPersistentContainer {
    
    static let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mentormate.PersistentHistoryTracking")!
    let storeDescription = NSPersistentStoreDescription(url: url)
    
    func enablePersistentHistoryTracking() {
        let storeDescription = persistentStoreDescriptions.first
        storeDescription?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    }
    
    override class func defaultDirectoryURL() -> URL {
        return url
    }
}

