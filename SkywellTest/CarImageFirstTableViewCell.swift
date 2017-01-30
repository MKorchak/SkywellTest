//
//  CarImageFirstTableViewCell.swift
//  SkywellTest
//
//  Created by Misha Korchak on 26.01.17.
//  Copyright © 2017 Misha Korchak. All rights reserved.
//

import UIKit

class CarImageFirstTableViewCell: UITableViewCell {
    
    var mainView: UIView?
    var carImageFirst: UIImageView?
    var addCarImageView: UIView?
    var addCarImage: UIImageView?
    
    var mainViewFrame = CGRect(
        x: 0,
        y: 0,
        width: AddCarViewController().carImageFirstTableViewFrame.width,
        height: AddCarViewController().carImageFirstTableViewFrame.width)
    
    var carImageFirstFrame = CGRect(
        x: 0,
        y: 0,
        width: round(200 * factor),
        height: round(200 * factor))
    
    var addCarImageFrame = CGRect(
        x: 0,
        y: 0,
        width: round(100 * factor),
        height: round(100 * factor))

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        resetUI()
        
        self.mainView = makeView(mainViewFrame, parent: self)
        rotateObject(self.mainView, angle: 90)
        mainView?.backgroundColor = UIColor(hexString: "#8BD200")
        
        carImageFirst = makeImageView(carImageFirstFrame, parent: mainView!)
        
        carImageFirst?.center = (mainView?.center)!
        
        
    }
    
    func resetUI() {
        self.mainView?.removeFromSuperview()
        self.mainView = nil
        
    }
    
    func makeCarImageAdd() {
        
        self.addCarImageView = makeView(carImageFirstFrame, parent: mainView!)
        addCarImageView?.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        addCarImageView?.center = (mainView?.center)!
        addCarImage = makeImageView(addCarImageFrame, parent: mainView!)
        addCarImage?.center = (mainView?.center)!
        addCarImage?.image = UIImage(named: "addButtonIcon.png")
        
    }
    
    func removeCarImageAdd() {
        self.addCarImageView?.removeFromSuperview()
        self.addCarImage?.removeFromSuperview()
    }
}
