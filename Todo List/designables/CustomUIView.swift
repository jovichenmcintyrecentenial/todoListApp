//
//  CustomUIView.swift
//  Todo List
//
//  Created by Jovi on 13/11/2022.
//

import Foundation

import UIKit

//custom UIView to give IB the ability to set cornerRadius on UIView from the UI
@IBDesignable
class CustomUIView: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable dynamic var borderColor:UIColor? {
        set {
            self.layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable dynamic var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

}
