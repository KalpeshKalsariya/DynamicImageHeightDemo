//
//  ViewController.swift
//  DynamicImageHeightDemo
//
//  Created by  Kalpesh on 19/04/25.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlet for the table view where data will be displayed
    @IBOutlet weak var tblview: UITableView!
    
    // Variable to hold the module layout information (e.g., section layout type)
    var Module_Layout: String?
    
    // Array to store menu items, which are used for dynamic content in the table view
    var arrOfMenuItemsNew: [Any]?
    
    // Constants to manage margin and padding values for better layout control
    let betweenMargin: CGFloat = 10
    let mainPadding: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the custom table view cell from the XIB file
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tblview.register(nib, forCellReuseIdentifier: "HomeTableViewCell")
        
        // Enable automatic row height calculation
        tblview.rowHeight = UITableView.automaticDimension
        tblview.estimatedRowHeight = 100
        
        // Set the delegate and data source for the table view
        tblview.delegate = self
        tblview.dataSource = self
    }
    
    // Function that returns an array of menu items based on the section number
    func getMenuItems(for section: Int) -> [[String: String]] {
        // Based on the section, return different menu items (dictionaries containing image URL, title, width, and height)
        switch section {
        case 0:
            return [
                ["imageURL": "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/big-sale-banner-design-template-69fd62ea9ecc86cf15cc8e8e6dce7a1c_screen.jpg?ts=1656924683", "title": "Banner 1", "width": "696", "height": "365"],
                ["imageURL": "https://www.brandeis.edu/cms-guide/building-editing/content-types/images/banner-single-sample.jpg", "title": "Banner 1", "width": "1920", "height": "768"],
                ["imageURL": "https://img.freepik.com/free-vector/traditional-happy-diwali-artistic-banner-design_1017-34439.jpg?t=st=1745050288~exp=1745053888~hmac=16f1123009175aa0198bd11dc55eca72a918ca5c53a6a9b8c12a3f2270f58aa2&w=1380", "title": "Banner 1", "width": "1062", "height": "409"]
            ]
        case 1:
            return [
                ["imageURL": "https://d23z30i20xtohh.cloudfront.net/banners/banner_1741314440891.png", "title": "Banner 1", "width": "1024", "height": "683"],
                ["imageURL": "https://d23z30i20xtohh.cloudfront.net/banners/banner_1741314421222.png", "title": "Banner 2", "width": "1024", "height": "683"],
                ["imageURL": "https://d23z30i20xtohh.cloudfront.net/banners/banner_1741314405247.png", "title": "Banner 3", "width": "1024", "height": "683"]
            ]
        case 2:
            return [
                ["imageURL": "https://d23z30i20xtohh.cloudfront.net/banners/banner_1703753722251.png", "title": "Banner 1", "width": "290", "height": "350"],
                ["imageURL": "https://d23z30i20xtohh.cloudfront.net/banners/banner_1741314326377.png", "title": "Banner 2", "width": "290", "height": "350"],
                ["imageURL": "https://d23z30i20xtohh.cloudfront.net/banners/banner_1741314356541.png", "title": "Banner 3", "width": "290", "height": "350"]
            ]
        case 3:
            return [
                ["imageURL": "https://d23z30i20xtohh.cloudfront.net/banners/banner_1564756447467.jpg", "title": "Banner 1", "width": "640", "height": "360"],
                ["imageURL": "https://d23z30i20xtohh.cloudfront.net/banners/banner_1703753620365.png", "title": "Banner 2", "width": "465", "height": "465"]
            ]
        case 4:
            return [
                ["imageURL": "https://d23z30i20xtohh.cloudfront.net/banners/banner_1564756447467.jpg", "title": "Banner 2", "width": "640", "height": "360"],
                ["imageURL": "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/big-sale-banner-design-template-69fd62ea9ecc86cf15cc8e8e6dce7a1c_screen.jpg?ts=1656924683", "title": "Banner 1", "width": "696", "height": "365"]
            ]
        default:
            return []
        }
    }
}

//MARK: - Table View Delegate & Data Source Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Return the number of sections in the table view (5 sections in total)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    // Return the number of rows for each section (currently 1 row per section)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Configure and return the custom cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom table view cell (HomeTableViewCell)
        guard let cell = tblview.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell else {
            return UITableViewCell() // Return a default cell if unable to dequeue the custom cell
        }
        
        // Get the menu items for the current section
        let arrOfMenuItems = getMenuItems(for: indexPath.section)
        
        // Pass the menu items and module layout to the cell for rendering
        cell.arrOfMenuItems = arrOfMenuItems
        cell.Module_Layout = "\(indexPath.section + 1)"
        self.Module_Layout = cell.Module_Layout
        
        // Clear background and set selection style to none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .none
        
        // Reload the collection view to apply the new data
        cell.collectionView.reloadData()
        
        // Re-layout the cell after adjusting the collection view's height
        cell.layoutIfNeeded()
        
        return cell  // Return the configured cell
    }
    
    // Calculate and return the height for each row based on the image dimensions
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
