//
//  CollectionViewCell.swift
//  RoboImages
//
//  Created by Mykhailo Vorontsov on 08/06/2016.
//  Copyright © 2016 Lebara. All rights reserved.
//

import UIKit

typealias DiscloseHandler = () -> Void
typealias AddHandlerHandler = () -> Void

class CollectionViewCell: UICollectionViewCell {
  
  //MARK: -Outlets
  @IBOutlet weak var thumbView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var discloseButton: UIButton!
  
  //MARK: -Handlers
  var discloseHandler:DiscloseHandler? {
    didSet {
      discloseButton.hidden = nil == discloseHandler
    }
  }
  
  var addHandler:AddHandlerHandler? {
    didSet {
      addButton.hidden = nil == addHandler
    }
  }
  
  //MARK: -Overrides
  override func awakeFromNib() {
    super.awakeFromNib()
    prepareForReuse()
  }
  
  override func prepareForReuse() {
    thumbView.image = UIImage.defaultImage()
    nameLabel.text = nil
    addButton.hidden = true
    discloseButton.hidden = true
    discloseHandler = nil
    addHandler = nil
  }
  
  //MARK: -Actions
  @IBAction func addButtonTouched(sender: AnyObject) {
    addHandler?()
  }
  
  @IBAction func discloseButtonTouched(sender: AnyObject) {
    discloseHandler?()
  }
  
}