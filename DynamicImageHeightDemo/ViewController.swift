//
//  ViewController.swift
//  DynamicImageHeightDemo
//
//  Created by Kalpesh on 19/04/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tblview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register custom cell
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tblview.register(nib, forCellReuseIdentifier: "HomeTableViewCell")
        
        tblview.rowHeight = UITableView.automaticDimension
        tblview.estimatedRowHeight = 100
        tblview.separatorStyle = .none
        tblview.delegate = self
        tblview.dataSource = self
    }
    
    // Menu items per section
    func getMenuItems(for section: Int) -> [[String: String]] {
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
                ["imageURL": "https://d23z30i20xtohh.cloudfront.net/banners/banner_1703753620365.png", "title": "Banner 2", "width": "465", "height": "465"],
                ["imageURL": "https://d23z30i20xtohh.cloudfront.net/banners/banner_1564756447467.jpg", "title": "Banner 1", "width": "640", "height": "360"]
            ]
        default:
            return []
        }
    }
    
    // Calculate max height using image metadata (width/height)
    func getMaxHeightForSection(section: Int) -> CGFloat? {
        let items = getMenuItems(for: section)
        let moduleLayout = section + 1
        var heights: [CGFloat] = []
        
        for (rowIndex, item) in items.enumerated() {
            guard
                let widthStr = item["width"],
                let heightStr = item["height"],
                let fileWidth = Float(widthStr),
                let fileHeight = Float(heightStr)
            else { continue }
            
            let bannerSize = BannerUtility.getBannerSize(
                rowIndex: rowIndex,
                fileWidth: CGFloat(fileWidth),
                fileHeight: CGFloat(fileHeight),
                moduleLayout: "\(moduleLayout)"
            )
            heights.append(bannerSize.height + 10)
        }
        
        return heights.max()
    }
}

// MARK: - Table View Delegate & Data Source
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
        cell.arrOfMenuItems = menuItems
        cell.Module_Layout = "\(indexPath.section + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getMaxHeightForSection(section: indexPath.section) ?? UITableView.automaticDimension
    }
}
