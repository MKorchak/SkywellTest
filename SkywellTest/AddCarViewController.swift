//
//  AddCarViewController.swift
//  SkywellTest
//
//  Created by Misha Korchak on 26.01.17.
//  Copyright © 2017 Misha Korchak. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class AddCarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var addCarScrollView: UIScrollView!
    @IBOutlet weak var carModel: UITextField!
    @IBOutlet weak var carPrice: UITextField!
    @IBOutlet weak var carEngine: UITextField!
    @IBOutlet weak var carTransmission: UITextField!
    @IBOutlet weak var carCondition: UITextField!
    @IBOutlet weak var carDescriptionTextView: UITextView!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let engineData = ["2.0i.e", "3.0i.e", "4.0i.e", "5.0i.e", "5.5i.e"]
    let transmissionData = [NSLocalizedString("manual", comment: "manual"), NSLocalizedString("automate", comment: "automate"), NSLocalizedString("burundi", comment: "burundi"), NSLocalizedString("typetronic", comment: "typetronic"),NSLocalizedString("cambodia", comment: "cambodia")]
    let conditionData = [NSLocalizedString("perfect", comment: "perfect"), NSLocalizedString("good", comment: "good"), NSLocalizedString("bad", comment: "bad")]
    
    
    let pickerFrame = CGRect(
        x: 0,
        y: round(100 * factor),
        width: UIScreen.main.bounds.size.width,
        height: round(450 * factor))
    
    var addCarImageButton: UIButton?
    let carImageFirstTableViewFrame = CGRect(
        x: 0,
        y: 0,
        width: round(270 * factor),
        height: UIScreen.main.bounds.size.width)
    
    var carImageFirstTableView: UITableView?
    var countOfImages = 0
    var countOfAllImages = 0
    var imagesArray: [UIImage] = []
    var arr: [UIImage] = []
    var mainPhoto: UIImage?
    
    var car: Car!
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadScreen()
        carImageFirstTableView = makeTableView(self.carImageFirstTableViewFrame, parent: self.addCarScrollView)
        carImageFirstTableView?.showsVerticalScrollIndicator = false
        carImageFirstTableView?.decelerationRate = UIScrollViewDecelerationRateFast
        rotateObject(carImageFirstTableView, y: carImageFirstTableViewFrame.origin.y, angle: -90)
        
        self.carImageFirstTableView?.delegate = self
        self.carImageFirstTableView?.dataSource = self
        
        carDescriptionTextView.delegate = self
        
        let enginePicker = makePicker(pickerFrame)
        enginePicker.tag = 1
        enginePicker.delegate = self
        enginePicker.dataSource = self
        let transmissionPicker = makePicker(pickerFrame)
        transmissionPicker.tag = 2
        transmissionPicker.delegate = self
        transmissionPicker.dataSource = self
        let conditionPicker = makePicker(pickerFrame)
        conditionPicker.tag = 3
        conditionPicker.delegate = self
        conditionPicker.dataSource = self
        let toolBar = makeToolBar(self, selector: #selector(AddCarViewController.donePicker), title: "Ok")
        carEngine.inputView = enginePicker
        carEngine.inputAccessoryView = toolBar
        carEngine.tag = 1
        carEngine.delegate = self
        carTransmission.inputView = transmissionPicker
        carTransmission.inputAccessoryView = toolBar
        carTransmission.tag = 2
        carTransmission.delegate = self
        carCondition.inputView = conditionPicker
        carCondition.inputAccessoryView = toolBar
        carCondition.tag = 3
        carCondition.delegate = self
        
        carModel.delegate = self
        carPrice.delegate = self
        
        carLabel.text = NSLocalizedString("car: ", comment: "car name")
        priceLabel.text = NSLocalizedString("Price: ", comment: "car price")
        descriptionLabel.text = NSLocalizedString("description: ", comment: "car description")
        carModel.placeholder = NSLocalizedString("Car model", comment: "car model placeholder")
        carPrice.placeholder = NSLocalizedString("Price", comment: "car price placeholder")
        carEngine.placeholder = NSLocalizedString("Engine", comment: "car engine placeholder")
        carTransmission.placeholder = NSLocalizedString("Transmission", comment: "car transmission placeholder")
        carCondition.placeholder = NSLocalizedString("Condition", comment: "car condition placeholder")
        title = NSLocalizedString("Add car", comment: "add car title")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func reloadScreen() {
        self.carImageFirstTableView?.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.tag == 1) {
            addCarScrollView.setContentOffset(CGPoint(x: 0, y: round(100 * factor)), animated: true)
        }
        else if(textField.tag == 2) {
            addCarScrollView.setContentOffset(CGPoint(x: 0, y: round(200 * factor)), animated: true)
        }
        else if(textField.tag == 3) {
            addCarScrollView.setContentOffset(CGPoint(x: 0, y: round(300 * factor)), animated: true)
        }
        else {
            addCarScrollView.setContentOffset(CGPoint(x: 0, y: round(50 * factor)), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addCarScrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.origin.y - round(140 * factor)), animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1) {
            return engineData.count
        }
        else if(pickerView.tag == 2) {
            return transmissionData.count
        }
        else {
            return conditionData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1) {
            return engineData[row]
        }
        else if(pickerView.tag == 2) {
            return transmissionData[row]
        }
        else {
            return conditionData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1) {
            carEngine.text = engineData[row]
        }
        else if(pickerView.tag == 2) {
            carTransmission.text = transmissionData[row]
        }
        else {
            carCondition.text = conditionData[row]
        }
    }
    
    func donePicker() {
        
        carEngine.resignFirstResponder()
        carTransmission.resignFirstResponder()
        carCondition.resignFirstResponder()
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        addCarScrollView.setContentOffset(CGPoint(x: 0, y: round(500 * factor)), animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        addCarScrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.origin.y - round(140 * factor)), animated: true)
    }
    
    private func getContext() -> NSManagedObjectContext? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func deleteCar() {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        do {
            let searchResults = try (getContext()?.fetch(fetchRequest))!
            for result in searchResults as [NSManagedObject] {
                let managedObjectData: NSManagedObject = result
                getContext()?.delete(managedObjectData)
                print("car deleted")
            }
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func tryGetCarImage(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func addCar(_ sender: UIBarButtonItem) {
        let model = carModel.text
        let price = carPrice.text
        let engine = carEngine.text
        let transmission = carTransmission.text
        let condition = carCondition.text
        let carDescription = carDescriptionTextView.text
        if model == "" || price == "" || engine == "" || transmission == "" || condition == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        else if self.mainPhoto == nil {
            let alertController = UIAlertController(title: "Oops", message: "You have to add photos.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }

        if let managedObjectContext = getContext() {
            
            self.car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: managedObjectContext) as! Car
            
            self.car.carModel = model
            self.car.price = price
            self.car.engine = engine
            self.car.transmission = transmission
            self.car.condition = condition
            self.car.carDescription = carDescription
            self.car.mainPhoto = UIImagePNGRepresentation(self.mainPhoto!) as NSData?
            
            self.car.countOfImages = Int64(countOfImages)
            let arrayData: NSData = NSKeyedArchiver.archivedData(withRootObject: imagesArray) as NSData
            self.car.carPhoto = arrayData
            do {
                try managedObjectContext.save()
                print("car saved")
        
            } catch {
                print(error)
                return
            }
        }
        CarListViewController().carListTableView?.reloadData()
        print("cars count = \(CarListViewController().cars.count)")
        _ = navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        imagesArray.append(chosenImage)
        if (countOfImages == 0) {
            mainPhoto = chosenImage
        }
        
        countOfImages += 1
        reloadScreen()
       
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(countOfImages != 0) {
            return countOfImages + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CarImageFirstTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CarImageFirstCell")
        cell.backgroundColor = UIColor(hexString: "#8BD200")
        cell.addCarImage?.image = imagesArray[indexPath.row]
        print(indexPath.row)
        if(indexPath.row == countOfImages) {
            cell.makeCarImageAdd()
            addCarImageButton = makeButton(CarImageFirstTableViewCell().carImageFirstFrame, parent: cell.addCarImageView!, target: self, selector: #selector(self.tryGetCarImage(_:)))
        }
        else if (indexPath.row < countOfImages) {
            cell.carImageFirst?.image = imagesArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return carImageFirstTableViewFrame.width
    }
}
