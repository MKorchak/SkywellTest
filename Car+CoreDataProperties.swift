//
//  Car+CoreDataProperties.swift
//  SkywellTest
//
//  Created by Misha Korchak on 28.01.17.
//  Copyright © 2017 Misha Korchak. All rights reserved.
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car");
    }

    @NSManaged public var carDescription: String?
    @NSManaged public var carModel: String?
    @NSManaged public var carPhoto: NSData?
    @NSManaged public var condition: String?
    @NSManaged public var engine: String?
    @NSManaged public var mainPhoto: NSData?
    @NSManaged public var price: String?
    @NSManaged public var transmission: String?
    @NSManaged public var countOfImages: Int64

}
