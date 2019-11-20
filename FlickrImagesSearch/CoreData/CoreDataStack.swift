//
//  CoreDataStack.swift
//  FlickrImagesSearch
//
//  Created by Вика on 20/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation
import CoreData

internal final class CoreDataStack {
    
    static let shared: CoreDataStack = {
        let coreDataStack = CoreDataStack()
        return coreDataStack
    }()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        let group = DispatchGroup()
        
        persistentContainer = NSPersistentContainer(name: "Model")
        group.enter()
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            print("storeDescription = \(storeDescription)")
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            group.leave()
        }
        group.wait()
    }
    
    func clear(completion: @escaping () -> ()) {
        persistentContainer.performBackgroundTask { (context) in
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: MOImage.fetchRequest())
            _ = try? context.execute(deleteRequest)
            try? context.save()
            completion()
        }
    }
}