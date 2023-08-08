//
//  ShowAllImages.swift
//  MVVM using Binding
//
//  Created by Sandeep Reddy on 03/08/23.
//

import UIKit

class ShowAllImages: UIViewController {
    var imagecacheForCollection = NSCache<NSString, UIImage>()
    var tImages = 0
    
    var dogImageAllLinks = [String]()
    @IBOutlet weak var myCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    }
extension ShowAllImages: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tImages
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCollectionViewCell else {
            // Failed to dequeue cell or casting failed, handle the error gracefully or return an empty cell.
            return UICollectionViewCell()
        }

        if indexPath.item < dogImageAllLinks.count {
            let imageURL = dogImageAllLinks[indexPath.item]

            // Load the image using the cell's loadImage function
            if let url = URL(string: imageURL) {
                // Pass the image cache to the cell
                cell.imageCache = imagecacheForCollection
                cell.loadImage(from: url)
            }

            // Additional styling or configurations for the cell...
            cell.myImageView.contentMode = .scaleToFill
            cell.myImageView.layer.cornerRadius = 25
        }

        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCollectionViewCell else {
//            // Failed to dequeue cell or casting failed, handle the error gracefully or return an empty cell.
//            return UICollectionViewCell()
//        }
//        // Ensure that the index is within the bounds of the dogImageAllLinks array
//        //        if indexPath.item < dogImageAllLinks.count {
//        //            let imageURL = dogImageAllLinks[indexPath.item]
//        if let image = imagecacheForCollection.object(forKey: NSString(string: "\(indexPath.row)")) {
//            if indexPath.item < dogImageAllLinks.count {
//                let imageURL = dogImageAllLinks[indexPath.item]
//                //
//                // Pass the image cache to the cell
//                cell.imageCache = imagecacheForCollection
//
//                // Load the image using the cell's loadImage function
//                if let url = URL(string: imageURL) {
//                    cell.loadImage(from: url)
//                }
//            }
//
//            // Additional styling or configurations for the cell...
//            cell.myImageView.contentMode = .scaleToFill
//            cell.myImageView.layer.cornerRadius = 25
//        }
//            return cell
//        }
//
        
        //            //if let image = imagecacheForCollection.object(forKey: NSString(string: "\(indexPath.row)")) {
        //            let imageURL = dogImageAllLinks[indexPath.item]
        //
        //                    // Load the image using the cell's loadImage function
        //                    if let url = URL(string: imageURL) {
        //                        cell.loadImage(from: url)
        //
        //                //cell.myImageView.image = image
        //                cell.myImageView.contentMode = .scaleToFill
        //                cell.myImageView.layer.cornerRadius = 25
        //            }
        //            return cell
        //        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = (collectionView.frame.size.width - 10)/2
            return CGSize(width: size, height: size)
        }
    }

