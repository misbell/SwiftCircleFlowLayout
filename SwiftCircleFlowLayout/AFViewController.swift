//
//  CollectionViewController.swift
//  SwiftCircleFlowLayout
//
//  Created by michael isbell on 8/20/18.
//  Copyright © 2018 michael isbell. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
//
//@property (nonatomic, assign) NSInteger cellCount;
//
//@property (nonatomic, strong) AFCollectionViewCircleLayout *circleLayout;
//@property (nonatomic, strong) AFCollectionViewFlowLayout *flowLayout;
//
//@property (nonatomic, strong) UISegmentedControl *layoutChangeSegmentedControl;



class AFViewController: UICollectionViewController,AFCollectionViewDelegateCircleLayout {
    

    
    
    var cellCount: NSInteger = 0
    var circleLayout: AFCollectionViewCircleLayout?
    var flowLayout: AFCollectionViewFlowLayout?
    var layoutChangeSegmentControl: UISegmentedControl?

    override var shouldAutorotate: Bool {
        get {
            return true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .all
        }
        
    }
    
    
  
    
    override func loadView() {
        // Create our view
        
        // Create instances of our layouts
        self.circleLayout = AFCollectionViewCircleLayout()
        self.flowLayout =  AFCollectionViewFlowLayout()
        
  
        // Create a new collection view with our flow layout and set ourself as delegate and data source.
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.circleLayout!)
       
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        // Register our classes so we can use our custom subclassed cell and header
        
        collectionView.register(AFCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
       
        
        // Set up the collection view geometry to cover the whole screen in any orientation and other view properties.
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
        
        // Finally, set our collectionView (since we are a collection view controller, this also sets self.view)
        self.collectionView = collectionView;
        
        // Setup our model
        self.cellCount = 12;
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       //?  self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(deleteItem))
        
        self.layoutChangeSegmentControl = UISegmentedControl(items: ["Circle", "Flow"])
        self.layoutChangeSegmentControl?.selectedSegmentIndex = 0

        self.layoutChangeSegmentControl?.selectedSegmentIndex = 0
       // self.layoutChangeSegmentControl?.segmentedControlStyle DEPRECATED
        self.layoutChangeSegmentControl?.addTarget(self, action: #selector(layoutChangeSegmentControlDidChangeValue), for: UIControl.Event.valueChanged)
        self.navigationItem.titleView = self.layoutChangeSegmentControl

    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        /*
         We override viewWillTransition(to size: with coordinator:) in order to add special behavior
         when the app changes size, especially when the device is rotated.
         In this demo app, we add an effect to make the items "pop" towards the viewer during the rotation,
         and then go back to normal afterwards.
         */
        
        super.viewWillTransition(to: size, with: coordinator)
        
        // doesn't really do anything here...
        // see adaptive elements app for good viewWillTransition example
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func layoutChangeSegmentControlDidChangeValue(_ sender: AnyObject) {
        // We need to explicitly tell the collection view layout that we want the change animated.
        
        if self.collectionView.collectionViewLayout == self.circleLayout {
            
            self.flowLayout?.invalidateLayout()
            self.collectionView.setCollectionViewLayout(self.flowLayout!, animated: true)
        }
        else {
            self.circleLayout?.invalidateLayout()
            self.collectionView.setCollectionViewLayout(self.circleLayout!, animated: true)
        
        }

    }

    @objc func addItem() {
        
        self.collectionView.performBatchUpdates ({
            self.cellCount = self.cellCount + 1
            let arr = NSArray(object: NSIndexPath(item: self.cellCount - 1, section: 0))
                
            self.collectionView.insertItems(at: arr as! [IndexPath])
        }, completion: nil)
        
    }
    
    @objc func deleteItem() {
        
        guard (self.cellCount > 1) else { return }
        
        self.collectionView.performBatchUpdates ({
            self.cellCount = self.cellCount - 1
            let arr = NSArray(object: NSIndexPath(item: self.cellCount, section: 0))
            
            self.collectionView.insertItems(at: arr as! [IndexPath])
        }, completion: nil)
        
        
    }
    
    
    // MARK: UICollectionViewDataSource
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.cellCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AFCollectionViewCell
        
        cell.labelString = "\(indexPath.row)"

        return cell
    }
    
    
    func rotationAngleForSupplementaryViewInCircleLayout( _ circleLayout: AFCollectionViewCircleLayout) -> CGFloat {
        
        
        var timeRatio = CGFloat(0.0)
        let date:NSDate = NSDate()
        let calendar:NSCalendar = NSCalendar.current as NSCalendar
        let components:NSDateComponents = calendar.components(
            NSCalendar.Unit(rawValue:  NSCalendar.Unit.minute.rawValue), from: date as Date) as NSDateComponents
        timeRatio = CGFloat(components.minute) / 60.0
        
        return (CGFloat(2 * Double.pi) * timeRatio)
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
