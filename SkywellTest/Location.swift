//
//  Location.swift
//  SkywellTest
//
//  Created by Misha Korchak on 26.01.17.
//  Copyright © 2017 Misha Korchak. All rights reserved.
//

import UIKit
import CoreLocation

/*class Location: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var weather: WeatherGetter!
    
    func getLocation() {
        
        guard CLLocationManager.locationServicesEnabled() else {
            showSimpleAlert(
                CarListViewController(),
                title: "Please turn on location services",
                message: "This app needs location services in order to report the weather " +
                    "for your current location.\n" +
                "Go to Settings → Privacy → Location Services and turn location services on."
            )
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                let alert = UIAlertController(
                    title: "Location services for this app are disabled",
                    message: "In order to get your current location, please open Settings for this app, choose \"Location\"  and set \"Allow location access\" to \"While Using the App\".",
                    preferredStyle: .alert
                )
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) {
                    action in
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                alert.addAction(cancelAction)
                alert.addAction(openSettingsAction)
                CarListViewController().present(alert, animated: true, completion: nil)
                return
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("Oops! Shouldn't have come this far.")
            }
            
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        weather.getWeatherByCoordinates(latitude: newLocation.coordinate.latitude,
                                        longitude: newLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            showSimpleAlert(CarListViewController(), title: "Can't determine your location",
                                 message: "The GPS and other location services aren't responding.")
        }
        print("locationManager didFailWithError: \(error)")
    }
}*/
