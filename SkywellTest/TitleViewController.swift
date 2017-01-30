//
//  TitleViewController.swift
//  SkywellTest
//
//  Created by Misha Korchak on 30.01.17.
//  Copyright © 2017 Misha Korchak. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var carPrice: UILabel!
    @IBOutlet weak var carEngine: UILabel!
    @IBOutlet weak var carTransmission: UILabel!
    @IBOutlet weak var carCondition: UILabel!
    @IBOutlet weak var carDesription: UITextView!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var carImageSecondTableView: UITableView!
    let carImageSecondTableViewFrame = CGRect(
        x: 0,
        y: 0,
        width: round(570 * factor),
        height: UIScreen.main.bounds.size.width)
    
    var arrayOfPhotos: [UIImage] = []
    var countOfPhotos: Int = 0
    
    var car: Car!

    override func viewDidLoad() {
        super.viewDidLoad()
        carImageSecondTableView = makeTableView(self.carImageSecondTableViewFrame, parent: self.view)
        carImageSecondTableView?.showsVerticalScrollIndicator = false
        carImageSecondTableView?.decelerationRate = UIScrollViewDecelerationRateFast
        carImageSecondTableView?.isPagingEnabled = true
        rotateObject(carImageSecondTableView, angle: -90)
        
        self.carImageSecondTableView?.delegate = self
        self.carImageSecondTableView?.dataSource = self
        
        carModel.text = car.carModel
        carPrice.text = car.price
        carEngine.text = NSLocalizedString("Engine: ", comment: "engine") + (car.engine!)
        carTransmission.text = NSLocalizedString("Transmission: ", comment: "transmission") + (car.transmission!)
        carCondition.text = NSLocalizedString("Condition: ", comment: "condition") + (car.condition!)
        carDesription.text = car.carDescription
        print(arrayOfPhotos.count)
        carLabel.text = AddCarViewController().carLabel.text
        priceLabel.text = AddCarViewController().priceLabel.text
        title = NSLocalizedString("Title", comment: "Title of car title")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CarImageSecondTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CarImageSecondCell")
        cell.backgroundColor = UIColor(hexString: "#8BD200")
        cell.carImageSecond?.image = arrayOfPhotos[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
    }
