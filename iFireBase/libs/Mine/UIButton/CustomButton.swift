//
//  CustomButton.swift
//  Currency Converter
//
//  Created by Amit Shukla on 03/01/18.
//  Copyright © 2018 Amit Shukla. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var useShadow:Bool = false{
        didSet{
            if(useShadow){
                dropShadow(scale: false)
            }
        }
    }
    @IBInspectable var shadowRadius:CGFloat = 0{
        didSet{
            if(useShadow){
                dropShadow(scale: false)
            }
        }
    }
    @IBInspectable var  ShadowX:Int = 1 {
        didSet{
            updateRadius()
        }
    }
    @IBInspectable var  ShadowY:Int = 1 {
        didSet{
            updateRadius()
        }
    }
    
    
    
    @IBInspectable var radius:Bool = false{
        didSet{
            updateRadius()
        }
    }
    @IBInspectable var radiusAmt:CGFloat = 0 {
        didSet{
            updateRadius()
        }
    }
    
    func updateRadius(){
        if(radius){
            self.layer.cornerRadius = radiusAmt;
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
            
//            self.layer.masksToBounds = true;
        }
    }
    
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: ShadowX, height: ShadowY)
        self.layer.shadowRadius = shadowRadius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
    
}
