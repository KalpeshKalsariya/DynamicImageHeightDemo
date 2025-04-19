//
//  CustomHeaderView.swift
//  DynamicImageHeightDemo
//
//  Created by  Kalpesh on 19/04/25.
//

import UIKit

// Custom header view class used in a collection view
class CustomHeaderView: UICollectionReusableView {
    
    // Create a UILabel instance for the header's title
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left  // Align text to the left
        return label
    }()
    
    // Initializer when the header view is created programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set the background color of the header view
        self.backgroundColor = .lightGray
        
        // Add the titleLabel as a subview of the header view
        addSubview(titleLabel)
    }
    
    // Required initializer for loading the header view from a storyboard or nib
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Set the background color of the header view
        self.backgroundColor = .lightGray
        
        // Add the titleLabel as a subview of the header view
        addSubview(titleLabel)
    }
    
    // Override layoutSubviews to adjust the frame of the titleLabel based on the header's size
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Adjust the titleLabel frame dynamically based on the view's bounds
        // Set the label's position with padding on the sides (20 units from the left and right)
        // Set the label's height with padding (10 units from the top and bottom)
        titleLabel.frame = CGRect(x: 20, y: 10, width: bounds.width - 40, height: bounds.height - 20)
    }
}
