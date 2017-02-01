//
//  CarListTableViewCell.swift
//  SkywellTest
//
//  Created by Misha Korchak on 26.01.17.
//  Copyright © 2017 Misha Korchak. All rights reserved.
//

import UIKit

class CarListTableViewCell: UITableViewCell {
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var carPrice: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        carLabel.text = NSLocalizedString("car: ", comment: "car name")
        priceLabel.text = NSLocalizedString("Price: ", comment: "car price")
        self.backgroundColor = UIColor(hexString: "#8BD200")
        self.tintColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func makeCell(image: UIImage, model: String, price: String) {
        carImage.image = image
        carModel.text = model
        carPrice.text = price
    }

}
