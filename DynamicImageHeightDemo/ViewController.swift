//
//  ViewController.swift
//  DynamicImageHeightDemo
//
//  Created by Kalpesh on 19/04/25.
//

import UIKit
import ImageIO

struct ImageItem {
    var imageURL: String
    var width: CGFloat?
    var height: CGFloat?
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tblview: UITableView!
    
    let imageCache = NSCache<NSString, UIImage>()
    var rowHeights: [Int: CGFloat] = [:]
    var sectionItems: [Int: [ImageItem]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblview.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        tblview.rowHeight = UITableView.automaticDimension
        tblview.estimatedRowHeight = 200
        
        preloadImages()
    }
    
    func getImageDimensions(from url: URL) -> CGSize? {
        // Create an image source from the URL
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }
        
        // Retrieve image properties
        let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any]
        
        // Extract width and height from properties
        if let width = properties?[kCGImagePropertyPixelWidth] as? CGFloat,
           let height = properties?[kCGImagePropertyPixelHeight] as? CGFloat {
            return CGSize(width: width, height: height)
        }
        
        return nil
    }
    
    func preloadImages() {
        // Start processing the sections sequentially
        preloadSection(0) // Start with section 0
    }

    func preloadSection(_ section: Int) {
        // Ensure we don’t process sections beyond the available ones
        guard section < 5 else { return }

        let items = getMenuItems(for: section)
        var updatedItems = items
        
        // Create a DispatchGroup to track the completion of all image downloads in the section
        let group = DispatchGroup()
        
        // Iterate through items in the section
        for (index, item) in items.enumerated() {
            guard let url = URL(string: item.imageURL) else { continue }

            // Enter the dispatch group before starting the task
            group.enter()

            // Perform image sourcing and property retrieval in a background queue
            DispatchQueue.global(qos: .background).async {
                // Ensure we can create the CGImageSource from the URL
                guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
                    // Exit if source creation fails
                    group.leave()
                    return
                }

                // Retrieve image properties
                let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any]

                // Extract width and height from properties
                if let width = properties?[kCGImagePropertyPixelWidth] as? CGFloat,
                   let height = properties?[kCGImagePropertyPixelHeight] as? CGFloat {
                    // Update the width and height for the item in the temporary array
                    updatedItems[index].width = width
                    updatedItems[index].height = height
                }
                
                // Leave the dispatch group after completing the task for this item
                group.leave()
            }
        }

        // Notify when all tasks are complete for this section
        group.notify(queue: .main) {
            // After all images have been processed, update sectionItems for the current section
            self.sectionItems[section] = updatedItems // Now update sectionItems

            // Update rowHeights if needed (based on your specific logic for calculating max height)
            if let height = self.getMaxHeightForSection(section: section) {
                self.rowHeights[section] = height
            }

            // Reload the section after all image processing is complete
            self.tblview.reloadSections(IndexSet(integer: section), with: .fade)
            
            // After the current section is finished, process the next section
            
            self.preloadSection(section + 1)
        }
        
        tblview.delegate = self
        tblview.dataSource = self
    }


    func getMenuItems(for section: Int) -> [ImageItem] {
        if let items = sectionItems[section] {
            return items
        }
        
        let items: [ImageItem]
        
        switch section {
        case 0:
            items = [
                ImageItem(imageURL: "https://img.freepik.com/free-vector/flat-abstract-business-youtube-thumbnail_23-2148925265.jpg?ga=GA1.1.2132131251.1745039823&semt=ais_hybrid&w=740"),
                ImageItem(imageURL: "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/big-sale-banner-design-template-69fd62ea9ecc86cf15cc8e8e6dce7a1c_screen.jpg?ts=1656924683"),
                ImageItem(imageURL: "https://www.brandeis.edu/cms-guide/building-editing/content-types/images/banner-single-sample.jpg"),
                ImageItem(imageURL: "https://img.freepik.com/free-vector/gradient-business-banner-template_23-2149717827.jpg?ga=GA1.1.2132131251.1745039823&semt=ais_hybrid&w=740"),
                ImageItem(imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1KpS7qg4ax-KGyt2XpAEDas1_iHrhVC4row&s"),
                ImageItem(imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3GioT9Z1rBy0N9x0XG_2p4sdYwGuu3T1q2g&s"),
                ImageItem(imageURL: "https://www.shutterstock.com/image-vector/sale-banner-template-design-big-260nw-1426828307.jpg"),
            ]
        case 1:
            items = [
                ImageItem(imageURL: "https://img.freepik.com/premium-psd/digital-marketing-agency-corporate-facebook-cover-template-design_550280-1998.jpg?ga=GA1.1.2132131251.1745039823&semt=ais_hybrid&w=740"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1741314440891.png"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1741314421222.png"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1741314405247.png")
            ]
        case 2:
            items = [
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1703753722251.png"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1741314326377.png"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1741314356541.png"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1703753620365.png")
            ]
        case 3:
            items = [
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1564756447467.jpg"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1703753620365.png"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1564756447467.jpg"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1703753620365.png")
            ]
        case 4:
            items = [
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1703753620365.png"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1564756447467.jpg"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1703753620365.png"),
                ImageItem(imageURL: "https://d23z30i20xtohh.cloudfront.net/banners/banner_1564756447467.jpg")
            ]
        default:
            items = []
        }
        
        sectionItems[section] = items
        return items
    }
    
    func getMaxHeightForSection(section: Int) -> CGFloat? {
        let items = getMenuItems(for: section)
        var heights: [CGFloat] = []
        
        for (rowIndex, item) in items.enumerated() {
            guard let fileWidth = item.width, let fileHeight = item.height else {
                continue
            }
            
            let bannerSize = BannerUtility.getBannerSize(
                rowIndex: rowIndex,
                fileWidth: fileWidth,
                fileHeight: fileHeight,
                moduleLayout: "\(section + 1)"
            )
            heights.append(bannerSize.height + 10)
        }
        
        return heights.max()
    }
}

// MARK: - UITableViewDelegate & DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblview.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell else {
            return UITableViewCell()
        }
        let menuItems = getMenuItems(for: indexPath.section)
        cell.imageItems = menuItems
        cell.Module_Layout = "\(indexPath.section + 1)"
        
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getMaxHeightForSection(section: indexPath.section) ?? UITableView.automaticDimension
    }
}

