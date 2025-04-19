//
//  HomeCollectionViewCell.swift
//  DynamicImageHeightDemo
//
//  Created by  Kalpesh on 19/04/25.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgBKG: UIImageView!
    var imageHeight: CGFloat = 0 {
            didSet {
                // Notify when the image height changes
                NotificationCenter.default.post(name: .imageHeightChanged, object: self)
            }
        }
    var indexPath: IndexPath?
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityIndicator.hidesWhenStopped = true
        imgBKG.addSubview(activityIndicator)
        activityIndicator.center = imgBKG.center
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imgBKG.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imgBKG.centerYAnchor)
        ])
        
        // Set corner radius for the image view
        self.imgBKG.layer.cornerRadius = 10  // Adjust the radius as needed
        self.imgBKG.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgBKG.image = nil
        activityIndicator.stopAnimating()
        indexPath = nil  // Clear the index path when reused
    }
    
    // Method to update the image size
    func updateImageSize(size: CGSize) {
        // Set the new size for the image view
        imgBKG.frame.size = size
        self.imageHeight = size.height
        
        // Post a notification when the image height changes
        NotificationCenter.default.post(name: .imageHeightChanged, object: self, userInfo: ["indexPath": indexPath!])
    }
}

extension Notification.Name {
    static let imageHeightChanged = Notification.Name("imageHeightChanged")
}
