//
//  HomeCollectionViewCell.swift
//  DynamicImageHeightDemo
//
//  Created by  Kalpesh on 19/04/25.
//

//
//  HomeCollectionViewCell.swift
//  DynamicImageHeightDemo
//
//  Created by  Kalpesh on 19/04/25.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgBKG: UIImageView!
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
        self.imgBKG.layer.cornerRadius = 5  // Adjust the radius as needed
        self.imgBKG.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgBKG.image = nil
        activityIndicator.stopAnimating()
    }
    
}
