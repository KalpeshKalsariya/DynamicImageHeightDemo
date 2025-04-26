📱 DynamicImageHeightDemo
`DynamicImageHeightDemo` is an sample project demonstrating how to dynamically adjust the height of an image view based on its content or aspect ratio. This is especially useful when displaying images of varying sizes in a scrollable layout, such as in blog posts, feed screens, or image galleries.

# ✨ Features
- Automatically resizes image height based on aspect ratio
- Smooth layout updates using Auto Layout
- Works with remote images
- Supports UIImageView inside UITableViewCell, UICollectionViewCell, or standalone views


# Visual Hierarchy:

This is a visual representation of the hierarchy for `UITableView`, `UICollectionView`, and `UIImageView` used in the app.

- **UITableView** (Parent View)
  - **UITableViewCell** (Child View of `UITableView`)
    - **UICollectionView** (Child View of `UITableViewCell`)
      - **UICollectionViewCell** (Child View of `UICollectionView`)
        - **UIImageView** (Child View of `UICollectionViewCell`)


### Hierarchy Overview:

1. **UITableView** (Parent View)
   - This is the root view that displays a list of sections and rows in the table.
   
2. **UITableViewCell** (Child View of `UITableView`)
   - Each row in the table is represented by a `UITableViewCell`.
   - It contains a `UICollectionView` to display images horizontally.
   
3. **UICollectionView** (Child View of `UITableViewCell`)
   - Inside the `UITableViewCell`, a `UICollectionView` is used to manage a collection of items (in your case, images).
   
4. **UICollectionViewCell** (Child View of `UICollectionView`)
   - Each item in the `UICollectionView` is represented by a `UICollectionViewCell`.
   - This cell contains an `UIImageView` to display images.

5. **UIImageView** (Child View of `UICollectionViewCell`)
   - This is where each image is displayed inside the `UICollectionViewCell`.
   - The image is loaded asynchronously from a URL and displayed once loaded.





