//
//  MOImage+CoreDataProperties.swift
//  FlickrImagesSearch
//
//  Created by Вика on 20/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//
//

import Foundation
import CoreData

extension MOImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOImage> {
        return NSFetchRequest<MOImage>(entityName: "Image")
    }

    @NSManaged public var image: NSData?
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Image", in: context)
        self.init(entity: entity!, insertInto: context)
    }
}
