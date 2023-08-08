//
//  MyCollectionViewCell.swift
//  MVVM using Binding
//
//  Created by Sandeep Reddy on 03/08/23.
//

import UIKit
class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var myImageView: UIImageView!
    
        var imageCache: NSCache<NSString, UIImage>?

        var imageDownloadTask: URLSessionDataTask?

        func loadImage(from url: URL) {
            // First, check if the image is already cached
            if let cachedImage = imageCache?.object(forKey: url.absoluteString as NSString) {
                myImageView.image = cachedImage
            } else {
                // If not, start the download task
                imageDownloadTask?.cancel() // Cancel any ongoing download task (if any)
                imageDownloadTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
                    guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else { return }

                    // Cache the downloaded image
                    self.imageCache?.setObject(image, forKey: url.absoluteString as NSString)

                    // Ensure that the cell is still displaying the same image URL that was requested.
                    DispatchQueue.main.async {
                        if url.absoluteString == self.imageURL {
                            self.myImageView.image = image
                        }
                    }
                }
                imageDownloadTask?.resume()
            }
        }

        // This variable will be used to keep track of the URL associated with the cell.
        // When a new image URL is assigned, it will be compared to this value in the completion block
        // to ensure that the correct image is displayed.
        private var imageURL: String?

        override func prepareForReuse() {
            super.prepareForReuse()
            // Cancel the ongoing download task when the cell is reused
            imageDownloadTask?.cancel()
            myImageView.image = nil
        }
    }

