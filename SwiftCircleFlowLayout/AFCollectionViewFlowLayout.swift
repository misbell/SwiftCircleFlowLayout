//
//  AFCollectionViewFlowLayout.swift
//  SwiftCircleFlowLayout
//
//  Created by michael isbell on 8/20/18.
//  Copyright © 2018 michael isbell. All rights reserved.
//

import UIKit

class AFCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var insertedRowSet: Set<NSInteger>?
    var deletedRowSet: Set<NSInteger>?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    

    override init() {
        
        super.init()
        self.itemSize = CGSize(width: 200.0, height: 200.0)
        self.sectionInset = UIEdgeInsets(top: 13.0, left: 13.0, bottom: 13.0, right: 13.0)
        self.minimumInteritemSpacing = 13.0
        self.minimumLineSpacing = 13.0
        
        
        // Must instantiate these in init or else they'll always be empty
        self.insertedRowSet = Set()
        self.deletedRowSet = Set()
        
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        
        super.prepare(forCollectionViewUpdates: updateItems)
        
        for (_, updateItem) in updateItems.enumerated() {

            if updateItem.updateAction == UICollectionViewUpdateItem.Action.insert {
                self.insertedRowSet?.insert(updateItem.indexPathAfterUpdate!.item)
            } else if updateItem.updateAction == UICollectionViewUpdateItem.Action.delete {
                 self.deletedRowSet?.insert(updateItem.indexPathBeforeUpdate!.item)
            }
        }
        
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        self.insertedRowSet?.removeAll(keepingCapacity: true)
        self.deletedRowSet?.removeAll(keepingCapacity: true)
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        var attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        if (self.insertedRowSet?.contains(itemIndexPath.item))! {
            attributes = self.layoutAttributesForItem(at: itemIndexPath)
            attributes!.alpha = 0.0;
            attributes!.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
            attributes!.transform3D = CATransform3DRotate(attributes!.transform3D, CGFloat(Double.pi / 4), 0, 0, 1);
        }
        
        return attributes
        
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        var attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        if (self.deletedRowSet?.contains(itemIndexPath.item))! {
            attributes = self.layoutAttributesForItem(at: itemIndexPath)
            attributes!.alpha = 0.0;
            attributes!.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
            attributes!.transform3D = CATransform3DRotate(attributes!.transform3D, CGFloat(Double.pi / 4), 0, 0, 1);
            return attributes
        }
        
        return attributes
    }
    

    
}
