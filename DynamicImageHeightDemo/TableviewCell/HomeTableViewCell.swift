//
//  HomeTableViewCell.swift
//  DynamicImageHeightDemo
//
//  Created by  Kalpesh on 19/04/25.
//

import UIKit

// Custom UITableViewCell subclass to represent each cell in the table view
class HomeTableViewCell: UITableViewCell {
    
    // IBOutlet for the collection view that will display images horizontally
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Flow layout used for the collection view
    var flowLayout: UICollectionViewFlowLayout?
    
    // Module layout type (used to manage different layouts for sections)
    var Module_Layout: String?
    
    // Array of menu items that holds image data (URL, title, etc.)
    var arrOfMenuItems: [[String: String]] = []
    
    // Section identifier or name (can be used to distinguish between sections in future logic)
    var section: String = ""
    
    @IBOutlet weak var heightCollectionViewConstraint: NSLayoutConstraint!
    // Variable to hold dynamic image size calculated based on the image data
    var dynamicImageSize: CGSize = .zero
    
    // A simple image cache using NSCache
    let imageCache = NSCache<NSString, UIImage>()
    
    // Called when the cell is first loaded into memory (initialization setup)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialize and configure the collection view layout (for horizontal scrolling)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10  // Space between items horizontally
        layout.minimumLineSpacing = 10  // Space between rows (vertically)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)  // Insets for the section (left and right)
        layout.scrollDirection = .horizontal  // Set collection view to scroll horizontally
        
        // Apply the layout to the collection view
        self.collectionView.collectionViewLayout = layout
        
        // Register the custom collection view cell from the XIB file
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        // Set delegate and data source for the collection view
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Register for notifications when image size changes
        NotificationCenter.default.addObserver(self, selector: #selector(imageHeightChanged(_:)), name: .imageHeightChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // This method is called when the image height changes
    @objc func imageHeightChanged(_ notification: Notification) {
        if let cell = notification.object as? HomeCollectionViewCell {
            // Invalidate the layout or reload the specific item
            //            collectionView.reloadItems(at: [indexPath])
            
            //            let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
            self.heightCollectionViewConstraint.constant = cell.imageHeight
            // Notify the parent table view to update its layout
            updateTableViewRowHeight(collectionView: collectionView)
        }
    }
    
    // Called when the cell is selected (for UI updates during selection)
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state (can customize the cell when selected)
    }
    
    func loadImage(for item: [String: String], into cell: HomeCollectionViewCell, rowIndex: Int, moduleLayout: String, completion: @escaping (UIImage?) -> Void) {
        // Remove any existing image and show loader
        cell.imgBKG.image = nil
        cell.activityIndicator.startAnimating()
        
        guard let imageURLString = item["imageURL"],
              let imageURL = URL(string: imageURLString) else {
            cell.activityIndicator.stopAnimating()
            completion(nil)
            return
        }
        
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: imageURLString as NSString) {
            cell.imgBKG.image = cachedImage
            cell.imgBKG.contentMode = .scaleAspectFit
            cell.activityIndicator.stopAnimating()
            let imageSize = BannerUtility.getBannerSize(rowIndex: rowIndex, fileWidth: cachedImage.size.width, fileHeight: cachedImage.size.height, moduleLayout: moduleLayout)
            cell.updateImageSize(size: imageSize) // Assuming you have a method to update the cell size
            completion(cachedImage) // Return cached image
            return
        }
        
        // Fetch image from network in background
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("Image download error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                }
                completion(nil) // Return nil if there's an error
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                // Cache the image
                self.imageCache.setObject(image, forKey: imageURLString as NSString)
                
                // Update UI on main thread
                DispatchQueue.main.async {
                    cell.imgBKG.image = image
                    cell.imgBKG.contentMode = .scaleAspectFit
                    cell.activityIndicator.stopAnimating()
                    let imageSize = BannerUtility.getBannerSize(rowIndex: rowIndex, fileWidth: image.size.width, fileHeight: image.size.height, moduleLayout: moduleLayout)
                    cell.updateImageSize(size: imageSize) // Assuming you have a method to update the cell size
                }
                completion(image) // Return the loaded image
            } else {
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                }
                completion(nil) // Return nil if the image couldn't be created
            }
        }.resume()
    }
    
    func updateTableViewRowHeight(collectionView: UICollectionView) {
        if let tableViewCell = collectionView.superview as? HomeTableViewCell {
            tableViewCell.setNeedsLayout()  // Ask the table view to re-layout
        }
    }
}

// MARK: - UICollectionView Delegate, DataSource, and FlowLayout Methods
extension HomeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // Return the number of sections in the collection view (fixed to 1 section here)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Return the number of items in the collection view section based on the array of menu items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfMenuItems.count  // The number of menu items will be the number of collection view cells
    }
    
    // Configure each collection view cell (display image and other data)
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue the custom cell for the collection view
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()  // Return a default cell if the custom one cannot be dequeued
        }
        
        // Get the current item (dictionary containing image URL, title, width, and height)
        let item = arrOfMenuItems[indexPath.item]
        //        loadImage(for: item, into: cell)
        cell.indexPath = indexPath
        loadImage(for: item, into: cell, rowIndex: indexPath.row, moduleLayout: Module_Layout ?? "0") { [weak self] image in
            guard let self = self else { return }
            
            if let loadedImage = image {
                // Update UI on main thread
                DispatchQueue.main.async {
                    cell.imgBKG.image = loadedImage
                    self.updateTableViewRowHeight(collectionView: collectionView)
                }
            } else {
                cell.imgBKG.image = nil
            }
        }
        return cell  // Return the configured cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    // Return the minimum spacing between items in the collection view (horizontal spacing between items)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10  // Set the minimum spacing to 10 points
    }
    
    // Return the minimum line spacing between rows in the collection view (vertical spacing)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10  // Set the minimum line spacing to 10 points
    }
    
    // Return the size for each collection view item (dynamic size based on the image's dimensions)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Get the current item data for the collection view cell (image dimensions)
        let item = arrOfMenuItems[indexPath.item]
        
        // Extract the image width and height from the dictionary (convert from strings to numbers)
        guard
            let widthStr = item["width"],
            let heightStr = item["height"],
            let fileWidth = Float(widthStr),
            let fileHeight = Float(heightStr)
        else {
            return .zero  // Return a size of zero if the necessary data is missing or invalid
        }
        
        // Use the BannerUtility class to calculate the dynamic banner size based on the image dimensions and module layout
        let bannerSize = BannerUtility.getBannerSize(
            rowIndex: indexPath.row,  // Pass the current row index to manage the layout
            fileWidth: CGFloat(fileWidth),  // Convert the image width to CGFloat
            fileHeight: CGFloat(fileHeight),  // Convert the image height to CGFloat
            moduleLayout: self.Module_Layout ?? "0"  // Use the module layout string, default to "0" if nil
        )
        
        // Return the calculated size for the item
        return bannerSize
    }
}
