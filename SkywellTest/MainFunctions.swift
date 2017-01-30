//
//  MainFunctions.swift
//  SkywellTest
//
//  Created by Misha Korchak on 26.01.17.
//  Copyright © 2017 Misha Korchak. All rights reserved.
//

import Foundation
import UIKit

let factor: CGFloat = UIScreen.main.bounds.size.width / 750

func showSimpleAlert(_ viewController: UIViewController,title: String, message: String) {
    let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert
    )
    let okAction = UIAlertAction(
        title: "OK",
        style:  .default,
        handler: nil
    )
    alert.addAction(okAction)
    viewController.present(
        alert,
        animated: true,
        completion: nil
    )
}

func makeView(_ frame: CGRect, parent: AnyObject) -> UIView? {
    let _vwObject: UIView? = UIView(frame: frame)
    
    _vwObject?.backgroundColor = UIColor.clear
    
    parent.addSubview(_vwObject!)
    
    return _vwObject!
}

func makeTableView(_ frame: CGRect, parent: AnyObject) -> UITableView? {
    let _tbvwObject: UITableView? = UITableView(frame: frame)
    
    _tbvwObject?.backgroundColor = UIColor.clear
    _tbvwObject?.separatorStyle = UITableViewCellSeparatorStyle.none
    _tbvwObject?.isEditing = false
    _tbvwObject?.allowsSelection = false
    _tbvwObject?.isScrollEnabled = true
    
    parent.addSubview(_tbvwObject!)
    
    return _tbvwObject!
}

func makeImageView(_ frame: CGRect, parent: AnyObject) -> UIImageView? {
    let _ivwObject: UIImageView? = UIImageView(frame: frame)
    
    _ivwObject?.backgroundColor = UIColor.clear
    
    parent.addSubview(_ivwObject!)
    
    return _ivwObject!
}

func makeButton(_ frame: CGRect, parent: AnyObject, target: AnyObject, selector: Selector) -> UIButton? {
    let _btObject: UIButton? = UIButton(frame: frame)
    
    _btObject?.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
    _btObject?.backgroundColor = UIColor.clear
    
    parent.addSubview(_btObject!)
    
    return _btObject!
}

func makePicker(_ frame: CGRect) -> UIPickerView{
    let picker: UIPickerView
    picker = UIPickerView(frame: frame)
    picker.backgroundColor = UIColor.white
    
    picker.showsSelectionIndicator = true
    return picker
}

func makeToolBar(_ target: AnyObject, selector: Selector, title: String) -> UIToolbar {
    let toolBar = UIToolbar()
    toolBar.barStyle = UIBarStyle.default
    toolBar.isTranslucent = true
    toolBar.barTintColor = UIColor.blue
    toolBar.tintColor = UIColor.white
    
    toolBar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: target, action: selector)
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    
    
    toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    return toolBar
}

func rotateObject(_ object: UIView?, x: CGFloat = 0, y: CGFloat = 0, angle: CGFloat) {
    object?.transform = CGAffineTransform(rotationAngle: angle * CGFloat(M_PI) / 180)
    
    var _frame = object!.frame
    _frame.origin.x = x
    _frame.origin.y = y
    object?.frame = _frame
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

