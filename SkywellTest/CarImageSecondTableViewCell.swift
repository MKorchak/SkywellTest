//
//  CarImageSecondTableViewCell.swift
//  SkywellTest
//
//  Created by Misha Korchak on 30.01.17.
//  Copyright © 2017 Misha Korchak. All rights reserved.
//

import UIKit

class CarImageSecondTableViewCell: UITableViewCell {
    
    var mainView: UIView?
    var carImageSecond: UIImageView?
    
    var mainViewFrame = CGRect(
        x: 0,
        y: 0,
        width: UIScreen.main.bounds.size.width,
        height: TitleViewController().carImageSecondTableViewFrame.width)
    
    var carImageSecondFrame = CGRect(
        x: 0,
        y: 0,
        width: UIScreen.main.bounds.size.width,
        height: TitleViewController().carImageSecondTableViewFrame.width)

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
        
        carImageSecond = makeImageView(carImageSecondFrame, parent: mainView!)
        
    }
    
    func resetUI() {
        self.mainView?.removeFromSuperview()
        self.mainView = nil
        
    }

}
