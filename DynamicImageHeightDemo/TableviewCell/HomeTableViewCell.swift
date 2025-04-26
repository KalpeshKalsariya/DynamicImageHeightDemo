//
//  HomeTableViewCell.swift
//  DynamicImageHeightDemo
//
//  Created by  Kalpesh on 19/04/25.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var Module_Layout: String?
    var imageItems = [ImageItem]()
    let imageCache = NSCache<NSString, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
    }
    
    func loadImageNew(for item: String, into cell: HomeCollectionViewCell, rowIndex: Int, moduleLayout: String?, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: item as NSString) {
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                completion(cachedImage)
            }
            return
        }
        
        guard let url = URL(string: item) else { return }
        
        // Start asynchronous download
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Image download failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    completion(nil)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to convert image data")
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    completion(nil)
                }
                return
            }
            
            // Cache image once downloaded
            self.imageCache.setObject(image, forKey: item as NSString)
            
            // Complete image download and update UI on the main thread
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                completion(image)
            }
        }.resume()
    }
    
    
    
}

// MARK: - UICollectionView DataSource & Delegate

extension HomeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard indexPath.item < imageItems.count else {
            // Return a default cell or handle the error appropriately
            cell.imgBKG.image = nil
            return cell
        }
        
        let item = imageItems[indexPath.item]
        
        // Load image asynchronously
        loadImageNew(for: item.imageURL, into: cell, rowIndex: indexPath.item, moduleLayout: Module_Layout) { image in
            DispatchQueue.main.async {
                cell.imgBKG.image = image
            }
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = imageItems[indexPath.item]
        if let width = item.width, let height = item.height {
            return BannerUtility.getBannerSize(
                rowIndex: indexPath.item,
                fileWidth: width,
                fileHeight: height,
                moduleLayout: Module_Layout ?? "1"
            )
        }
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

