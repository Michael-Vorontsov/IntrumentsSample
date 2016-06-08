//
//  CollectionViewController.swift
//  RoboImages
//
//  Created by Mykhailo Vorontsov on 08/06/2016.
//  Copyright © 2016 Lebara. All rights reserved.
//

import UIKit


private let const = (
  count : 100,
  cellId: "Cell"
)

class CollectionViewController: UICollectionViewController {
  
  //MARK: -Item arrays
  lazy var generatedRobots:[String] = {return [String]()}()
  lazy var disclosedRobots:[String] = {return [String]()}()
  lazy var savedRobots:[String] = {return [String]()}()
  
  //MARK: -Utility
  lazy var utility:RobotUtility = {
    return RobotUtility()
  }()
  
  //MARK: -Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    generate()
  }
  
  //MARK: -Helpers
  func generate() {
    var newGeneratedRobots = [String]()
    for _ in 0...const.count {
      let robot = String(rand())
      newGeneratedRobots.append(robot)
    }
    generatedRobots = newGeneratedRobots
    collectionView?.reloadData()
  }
  
  // MARK: -CollectionViewDataSource
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return generatedRobots.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(const.cellId, forIndexPath: indexPath) as! CollectionViewCell
    let robot = generatedRobots[indexPath.row]
    
    let disclosed = disclosedRobots.contains(robot)
    
    cell.nameLabel.text = robot
    utility.loadRobotImage(robot) { (image) in
      if disclosed {
        cell.thumbView.image = image
      } else {
        let tonnedImage = image.applyTonalFilter()
        cell.thumbView.image = tonnedImage
      }
    }
    
    cell.discloseHandler = {
      if disclosed {
        if let index = self.disclosedRobots.indexOf(robot) {
          self.disclosedRobots.removeAtIndex(index)
        }
      } else {
        self.disclosedRobots.append(robot)
      }
      self.collectionView?.reloadItemsAtIndexPaths([indexPath])
    }
    
//// Save Robots
//    
//    let saved = savedRobots.contains(robot)
//    cell.addButton.enabled = !saved
//    cell.addHandler = { [unowned self] in
//      self.utility.saveRobot(robot, handler: { (success) in
//        dispatch_async(dispatch_get_main_queue()) {
//          if success {
//            self.savedRobots.append(robot)
//            self.collectionView?.reloadItemsAtIndexPaths([indexPath])
//          }
//        }
//      })
//    }
    
    return cell
  }
  
}
