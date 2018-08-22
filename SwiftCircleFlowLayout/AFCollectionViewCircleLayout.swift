//
//  AFCollectionViewCircleLayout.swift
//  SwiftCircleFlowLayout
//
//  Created by michael isbell on 8/20/18.
//  Copyright © 2018 michael isbell. All rights reserved.
//

import UIKit


protocol AFCollectionViewDelegateCircleLayout {

    func rotationAngleForSupplementaryViewInCircleLayout(_ circleLayout: AFCollectionViewCircleLayout) -> CGFloat
    
}

let kItemDimension =  70.0

let AFCollectionViewFlowDecoration = "DecorationView";


class AFCollectionViewCircleLayout: UICollectionViewLayout {
    
    var center: CGPoint?
    var radius: CGFloat?
    var cellCount: NSInteger?
    


    var insertedRowSet: Set<NSInteger>?
    var deletedRowSet: Set<NSInteger>?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    
    override init() {
        
        super.init()
        
        self.register(AFDecorationView.self, forDecorationViewOfKind: AFCollectionViewFlowDecoration)
        
        // Must instantiate these in init or else they'll always be empty
        self.insertedRowSet = Set()
        self.deletedRowSet = Set()
        
    }
    
    override func prepare() {
  
        super.prepare()
        
        let size = self.collectionView?.bounds.size
        self.cellCount = (self.collectionView?.numberOfItems(inSection: 0))!
        self.center = CGPoint(x: (size?.width)! / 2.0, y: (size?.height)! / 2.0)
        self.radius = min((size?.width)!, (size?.height)!) / 2.5

    }
    
    override var collectionViewContentSize: CGSize {
        let bounds = self.collectionView?.bounds
        return bounds!.size;
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        attributes.size = CGSize(width: kItemDimension, height: kItemDimension)
        
        let cos: Float = cosf(Float(Double(2.0 * Double(indexPath.item) * Double.pi / Double(self.cellCount!) - Double.pi/2.0)))
        let sin: Float  = sinf(Float(2 * Double(indexPath.item) * Double.pi / Double(self.cellCount!) - Double.pi/2.0))
        
        attributes.center = CGPoint(x: (self.center!.x + self.radius! * CGFloat(cos)) ,  y: (self.center!.y + self.radius! * CGFloat(sin) ))
        
        attributes.transform3D = CATransform3DMakeRotation(CGFloat((2.0 * Double.pi * Double(indexPath.item)) / Double(self.cellCount!)), 0, 0, 1)
        
        
        return attributes
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes = (0..<self.cellCount!).map({ NSIndexPath(item: $0, section: 0) }).map({ layoutAttributesForItem(at: $0 as IndexPath )! })
        
        if rect.contains(self.center!) {
            attributes.append(self.layoutAttributesForDecorationView(ofKind: AFCollectionViewFlowDecoration, at: NSIndexPath(row: 0, section: 0) as IndexPath )!)
        }
            
        return attributes
        
//        it gets better! for instance, you can combine the two `map`s into one by just initializing `IndexPath` directly rather than converting from `NSIndexPath`
//
//            and drop the `self.` everywhere
//            `var attributes = (0..<cellCount!).map { layoutAttributesForItem(at: IndexPath(item: $0, section: 0)) }` (using trailing closure syntax, too)
//
        
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
            attributes!.center = self.center!
            
            return attributes
        }
        
        return nil
        
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        var attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        if (self.deletedRowSet?.contains(itemIndexPath.item))! {
            attributes = self.layoutAttributesForItem(at: itemIndexPath)
            attributes!.alpha = 0.0;
            attributes!.center = self.center!
            
            attributes!.transform3D = CATransform3DConcat(CATransform3DMakeRotation(CGFloat((2.0 * Double.pi * Double(itemIndexPath.item)) / Double(self.cellCount! + 1)), 0, 0, 1), CATransform3DMakeScale(0.1, 0.1, 1.0))
            
            return attributes
        }
        
        return nil
    }
    
    
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: AFCollectionViewFlowDecoration, with: indexPath)

        if elementKind == AFCollectionViewFlowDecoration {
            
            var rotationAngle = 0.0
            
            // swifty way to check for protocol conformance
            if (self.collectionView?.delegate as? AFCollectionViewDelegateCircleLayout) != nil {
                  rotationAngle = 0
            }
            
            layoutAttributes.size = CGSize(width: 20, height: 200)
            layoutAttributes.center = self.center!
            
            layoutAttributes.transform3D = CATransform3DMakeRotation(CGFloat(rotationAngle), 0, 0, 1 )
            layoutAttributes.zIndex = -1
            
        }
        
        
        return layoutAttributes
    }
   
}
