//
//  CarListViewController.swift
//  SkywellTest
//
//  Created by Misha Korchak on 25.01.17.
//  Copyright © 2017 Misha Korchak. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class CarListViewController: UIViewController, WeatherGetterDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var carListTableView: UITableView!
    
    
    let locationManager = CLLocationManager()
    var weather: WeatherGetter!
    var weatherData: WeatherData!
    
    var cars: [Car] = []
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>!
    
    private func getLocation() {
        
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


    override func viewDidLoad() {
        super.viewDidLoad()
        self.carListTableView.reloadData()
        print("cars count = \(cars.count)")

        weather = WeatherGetter(delegate: self)
        getLocation()
        carListTableView.backgroundColor = UIColor(hexString: "#8BD200")
        
        self.carListTableView.delegate = self
        self.carListTableView.dataSource = self
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        let sortDescriptor = NSSortDescriptor(key: "carDescription", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                cars = fetchResultController.fetchedObjects as! [Car]
            } catch {
                print(error)
            }
        }
        title = NSLocalizedString("Car list", comment: "car list title")
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        carListTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let _newIndexPath = newIndexPath {
                carListTableView.insertRows(at: [_newIndexPath], with: .fade)
            }
        case .delete:
            if let _newIndexPath = newIndexPath {
                carListTableView.deleteRows(at: [_newIndexPath], with: .fade)
            }
        case .update:
            if let _newIndexPath = newIndexPath {
                carListTableView.reloadRows(at: [_newIndexPath], with: .fade)
            }
        default:
            carListTableView.reloadData()
        }
        cars = (controller.fetchedObjects as? [Car])!
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        carListTableView.endUpdates()
    }
    
    func didGetWeather(_ weather: Weather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.weatherLabel.text = weather.weatherDescription.capitalized
            if(weather.tempCelsius > 0) {
                self.temperatureLabel.text = "+\(Int(round(weather.tempCelsius)))°"
            }
            else {
                self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
            }
            var imageURL: String?
            imageURL = "http://openweathermap.org/img/w/\(weather.weatherIconID).png"
            if let url = NSURL(string: imageURL!) {
                if let data = NSData(contentsOf: url as URL) {
                    self.weatherImage.image = UIImage(data: data as Data)
                    self.weatherImage.alpha = 0.7
                }
            }
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let fetchRequest: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
                do {
                    let searchResults = try managedObjectContext.fetch(fetchRequest)
                    for result in searchResults as [NSManagedObject] {
                        let managedObjectData:NSManagedObject = result
                        managedObjectContext.delete(managedObjectData)
                        print("weather deleted")
                    }
                } catch {
                    print("Error with request: \(error)")
                }
                self.weatherData = NSEntityDescription.insertNewObject(forEntityName: "WeatherData", into: managedObjectContext) as? WeatherData
                
                self.weatherData.city = self.cityLabel.text!
                self.weatherData.temperature = self.temperatureLabel.text!
                self.weatherData.weather = self.weatherLabel.text!
                self.weatherData.image = UIImagePNGRepresentation(self.weatherImage.image!) as NSData?
                
                do {
                    try managedObjectContext.save()
                    print("weather saved")
                } catch {
                    print(error)
                    return
                }
            }
        }
    }
    
    func didNotGetWeather(_ error: NSError) {
        DispatchQueue.main.async {
            showSimpleAlert(self, title: "Can't update the weather",
                                 message: "The weather service isn't responding.")
            let fetchRequest: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
            do {
                let searchResults = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest)
                for result in searchResults as [NSManagedObject] {
                    self.cityLabel.text = result.value(forKey: "city") as! String?
                    self.temperatureLabel.text = result.value(forKey: "temperature") as! String?
                    self.weatherLabel.text = result.value(forKey: "weather") as! String?
                    self.weatherImage.image = UIImage(data: (result.value(forKey: "image")) as! Data)
                    self.weatherImage.alpha = 0.7
                }
            } catch {
                print("Error with request: \(error)")
            }
        }
        print("didNotGetWeather error: \(error)")
    }

    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath) as! CarListTableViewCell
        let car = cars[indexPath.row]
        cell.makeCell(image: UIImage(data: car.mainPhoto as! Data)!, model: car.carModel!, price: car.price!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(actin, indexPath) -> Void in
            self.cars.remove(at: indexPath.row)
            
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let carToDelete = self.fetchResultController.object(at: indexPath) as? Car
                
                managedObjectContext.delete(carToDelete!)
                tableView.deleteRows(at: [indexPath], with: .fade)
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        })
        
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = carListTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! TitleViewController
                destinationController.car = cars[indexPath.row]
                destinationController.countOfPhotos = Int(cars[indexPath.row].countOfImages)
                let arrayOfPhotos = NSKeyedUnarchiver.unarchiveObject(with: cars[indexPath.row].carPhoto as! Data)
                destinationController.arrayOfPhotos = arrayOfPhotos as! [UIImage]
            }
        }
    }

}
