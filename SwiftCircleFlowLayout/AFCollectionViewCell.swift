//
//  AFCollectionViewCell.swift
//  SwiftCircleFlowLayout
//
//  Created by michael isbell on 8/20/18.
//  Copyright © 2018 michael isbell. All rights reserved.
//

import UIKit

class AFCollectionViewCell: UICollectionViewCell {
    
    
    var labelString: String? {
        get {
            if let aLabel = self.label {
                if let text = aLabel.text {
                    return text
                }
                else {return ""}
            } else {return ""}
        }
        set {
            if let aLabel = self.label {
                aLabel.text = labelString
            }
        }
    }
    var label: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {

        super.init(frame: frame)
 
        self.backgroundColor = UIColor.orange
        self.label = UILabel(frame: CGRect(x:0, y:0, width:frame.width, height:frame.height))
        self.label?.backgroundColor = UIColor.clear
        self.label?.textAlignment = NSTextAlignment.center
        self.label?.textColor = UIColor.white
        self.label?.font = UIFont.boldSystemFont(ofSize: 24)
        self.contentView.addSubview(self.label!)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.labelString = ""
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        self.label?.center = CGPoint(x: self.contentView.bounds.width / 2.0, y: self.contentView.bounds.height / 2.0)
        
    }
  

 
}
