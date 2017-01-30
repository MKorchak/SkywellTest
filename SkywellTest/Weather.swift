//
//  Weather.swift
//  SkywellTest
//
//  Created by Misha Korchak on 25.01.17.
//  Copyright © 2017 Misha Korchak. All rights reserved.
//

import Foundation


protocol WeatherGetterDelegate {
    func didGetWeather(_ weather: Weather)
    func didNotGetWeather(_ error: NSError)
}


// MARK: WeatherGetter
// ===================

class WeatherGetter {
    
    fileprivate let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    fileprivate let openWeatherMapAPIKey = "aab44dc4450ab05b72d3c5c181b1d788"
    
    fileprivate var delegate: WeatherGetterDelegate
    
    
    // MARK: -
    
    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
    func getWeatherByCity(_ city: String) {
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
        getWeather(weatherRequestURL)
    }
    
    func getWeatherByCoordinates(latitude: Double, longitude: Double) {
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(latitude)&lon=\(longitude)")!
        getWeather(weatherRequestURL)
    }
    
    fileprivate func getWeather(_ weatherRequestURL: URL) {
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 3
        
        // The data task retrieves the data.
        let dataTask = session.dataTask(with: weatherRequestURL, completionHandler: {
            (data, response, error) -> Void in
            if let networkError = error {
                // Case 1: Error
                // An error occurred while trying to get data from the server.
                self.delegate.didNotGetWeather(networkError as NSError)
            }
            else {
                // Case 2: Success
                // We got data from the server!
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherData = try JSONSerialization.jsonObject(
                        with: data!,
                        options: .mutableContainers) as! [String: AnyObject]
                    
                    // If we made it to this point, we've successfully converted the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Let's now used that dictionary to initialize a Weather struct.
                    let weather = Weather(weatherData: weatherData)
                    
                    // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                    self.delegate.didGetWeather(weather)
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    self.delegate.didNotGetWeather(jsonError)
                }
            }
        }) 
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
    
}

struct Weather {
    
    let dateAndTime: Date
    
    let city: String
    let country: String
    let longitude: Double
    let latitude: Double
    
    let weatherID: Int
    let mainWeather: String
    let weatherDescription: String
    let weatherIconID: String
    
    // OpenWeatherMap reports temperature in Kelvin,
    // which is why we provide celsius and fahrenheit
    // computed properties.
    fileprivate let temp: Double
    var tempCelsius: Double {
        get {
            return temp - 273.15
        }
    }
    
    var tempFahrenheit: Double {
        get {
            return (temp - 273.15) * 1.8 + 32
        }
    }
    let humidity: Int
    let pressure: Int
    let cloudCover: Int
    let windSpeed: Double
    
    // These properties are optionals because OpenWeatherMap doesn't provide:
    // - a value for wind direction when the wind speed is negligible
    // - rain info when there is no rainfall
    let windDirection: Double?
    let rainfallInLast3Hours: Double?
    
    let sunrise: Date
    let sunset: Date
    
    init(weatherData: [String: AnyObject]) {
        dateAndTime = Date(timeIntervalSince1970: weatherData["dt"] as! TimeInterval)
        city = weatherData["name"] as! String
        
        let coordDict = weatherData["coord"] as! [String: AnyObject]
        longitude = coordDict["lon"] as! Double
        latitude = coordDict["lat"] as! Double
        
        let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
        weatherID = weatherDict["id"] as! Int
        mainWeather = weatherDict["main"] as! String
        weatherDescription = weatherDict["description"] as! String
        weatherIconID = weatherDict["icon"] as! String
        
        let mainDict = weatherData["main"] as! [String: AnyObject]
        temp = mainDict["temp"] as! Double
        humidity = mainDict["humidity"] as! Int
        pressure = mainDict["pressure"] as! Int
        
        cloudCover = weatherData["clouds"]!["all"] as! Int
        
        let windDict = weatherData["wind"] as! [String: AnyObject]
        windSpeed = windDict["speed"] as! Double
        windDirection = windDict["deg"] as? Double
        
        if weatherData["rain"] != nil {
            let rainDict = weatherData["rain"] as! [String: AnyObject]
            rainfallInLast3Hours = rainDict["3h"] as? Double
        }
        else {
            rainfallInLast3Hours = nil
        }
        
        let sysDict = weatherData["sys"] as! [String: AnyObject]
        country = sysDict["country"] as! String
        sunrise = Date(timeIntervalSince1970: sysDict["sunrise"] as! TimeInterval)
        sunset = Date(timeIntervalSince1970:sysDict["sunset"] as! TimeInterval)
    }
    
}
