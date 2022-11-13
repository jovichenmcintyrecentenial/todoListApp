//
//  CircleUIButton.swift
//  Todo List
//
//  Created by Jovi on 13/11/2022.
//

import UIKit
//IB designable add ability to make button prefect circle no matter the height
@IBDesignable
class CircleUIButton: UIButton {

    @IBInspectable var enableDesign: Bool = false {
        didSet {
            if(enableDesign){
                layer.cornerRadius = layer.bounds.height/2
                layer.masksToBounds = layer.cornerRadius > 0
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(enableDesign){
            layer.cornerRadius = layer.bounds.height/2
            layer.masksToBounds = layer.cornerRadius > 0
        }
    }


}
