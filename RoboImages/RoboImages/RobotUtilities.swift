//
//  RobotUtilities.swift
//  RoboImages
//
//  Created by Mykhailo Vorontsov on 08/06/2016.
//  Copyright © 2016 Lebara. All rights reserved.
//

import UIKit

private let const = (
  filterName: "CIPhotoEffectTonal",
  defaultImage: "logo_transparent",
  thumbFormat: "https://robohash.org/%@.jpg?size=120x120",
  imageFormat: "https://robohash.org/%@.jpg?size=1000x1000"
)

typealias ImageLoadHandler = (image:UIImage) -> Void
typealias SaveRobotHandler = (success:Bool) -> Void

//MARK: -UIImage Extension
extension UIImage {
  func applyTonalFilter() -> UIImage? {
    let context = CIContext(options:nil)
    let filter: CIFilter! = CIFilter(name:const.filterName)
    let input = CoreImage.CIImage(image: self)
    filter.setValue(input, forKey: kCIInputImageKey)
    let outputImage = filter.outputImage
    
    let outImage = context.createCGImage(outputImage!, fromRect: outputImage!.extent)
    let returnImage = UIImage(CGImage: outImage)
    return returnImage
  }
  
  static func defaultImage() -> UIImage {
    return UIImage(named:const.defaultImage) ?? UIImage()
  }
  
}

//MARK: -ImageCache
private class ImageCache {
  var images = [String:UIImage]()
  
  func setImage(image: UIImage, forKey key: String) {
    images[key] = image
  }
  
  func imageForKey(key: String) -> UIImage? {
    return images[key]
  }
}

//MARK: -Utility
struct RobotUtility {
  
  static let sharedUtility:RobotUtility = RobotUtility()
  
  private let imageCache:ImageCache = ImageCache()
  
  /// Load image for robot from remote host
  func loadRobotImage(robotName:String, handler:ImageLoadHandler) {
    
    if let image = imageCache.imageForKey(robotName) {
      handler(image: image)
      return
    }
    
    let defaultImage = UIImage.defaultImage()
    guard let imageURL = NSURL(string: NSString(format: const.thumbFormat, robotName) as String) else {
      handler(image: defaultImage)
      return
    }
    // NSURLConnection Used for simplicity - completion handler shoulb be executed on main thread
    NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: imageURL),
                                            queue: NSOperationQueue.mainQueue())
    { (response, data, error) in
      guard let data = data, let image = UIImage(data:data)  else {
        handler(image: defaultImage)
        return
      }
      self.imageCache.setImage(image, forKey: robotName)
      handler(image: image)
    }
    
  }
  
  /// Load large image for robot and save it to document directory with same name
  func saveRobot(robotName:String, handler:SaveRobotHandler) {
    guard let robotURL = NSURL(string: NSString(format: const.imageFormat, robotName) as String) else {
      handler(success: false)
      return
    }
    
    // NSURLConnection Used for simplicity - completion handler shoulb be executed on main thread
    NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: robotURL),
                                            queue: NSOperationQueue.mainQueue())
    { (response, data, error) in
      guard let data = data  else {
        handler(success: false)
        return
      }
      let fileManager = NSFileManager.defaultManager()
      let documentsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
      let destinationURL = documentsURL.URLByAppendingPathComponent(robotName).URLByAppendingPathExtension(".jpg")
      let success = data.writeToURL(destinationURL, atomically: true)
      handler(success: success)
    }
  }
}
