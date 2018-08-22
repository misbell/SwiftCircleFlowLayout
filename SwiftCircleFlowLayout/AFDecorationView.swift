//
//  CollectionReusableView.swift
//  SwiftCircleFlowLayout
//
//  Created by michael isbell on 8/20/18.
//  Copyright © 2018 michael isbell. All rights reserved.
//

import UIKit

class AFDecorationView: UICollectionReusableView {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.backgroundColor =  UIColor.clear.cgColor
        gradientLayer.frame = self.bounds
        
        self.layer.mask = gradientLayer

        self.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.backgroundColor = UIColor.clear.cgColor
        gradientLayer.frame = self.bounds
        
        self.layer.mask = gradientLayer
        
    }
}
