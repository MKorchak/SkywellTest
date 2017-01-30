//
//  WeatherData+CoreDataProperties.swift
//  SkywellTest
//
//  Created by Misha Korchak on 28.01.17.
//  Copyright © 2017 Misha Korchak. All rights reserved.
//

import Foundation
import CoreData


extension WeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "WeatherData");
    }

    @NSManaged public var image: NSData?
    @NSManaged public var temperature: String?
    @NSManaged public var weather: String?
    @NSManaged public var city: String?

}
