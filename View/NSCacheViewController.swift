//
//  NSCacheViewController.swift
//  MVVM using Binding
//
//  Created by Sandeep Reddy on 03/08/23.
//

import UIKit

class NSCacheViewController: UIViewController {
    var dogallData: DogData?
    var dogImageAllLinks = [String]()
    var imageToCache = NSCache<NSString, UIImage>()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingWaitLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true

        // Do any additional setup after loading the view.
    }
    func fetchData() {
        let url = URL(string: "https://dog.ceo/api/breed/hound/images")
        let task =  URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) in
            guard let data = data, error == nil else {
                print("error data")
                return
            }
            var dogObject: DogData?
            do {
                dogObject = try JSONDecoder().decode(DogData.self, from: data)
            } catch {
                print("error: \(error)")
            }
            self.dogallData = dogObject
            self.dogImageAllLinks = self.dogallData!.message
            let totalImages = self.dogImageAllLinks.count
            var imgdata = 0
            var totalDownloadImage: Int = 0
            while imgdata<totalImages {
                let urlString = URL(string: self.dogImageAllLinks[imgdata])
                self.downloadImage(from: urlString!, counter: String(imgdata), completion: { value  in
                    if value == 1 {
                        totalDownloadImage += 1
                    }
                    DispatchQueue.main.async {
                        if totalDownloadImage == totalImages {
                            self.loadingWaitLabel.text = "all images download succesfully"
                            self.activityIndicator.stopAnimating()
                        }
                    }
                })
                 imgdata += 1
            }
        })
        task.resume()
    }
    func downloadImage(from url: URL, counter: String, completion: @escaping (_ result: Int) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error ) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data)
            else {
                return
            }
            self.imageToCache.setObject(image, forKey: NSString(string: counter))
            DispatchQueue.main.async {
                self.loadingWaitLabel.text = "Downloading Image \(counter).. wait"
            }
            completion(1)
        })
        dataTask.resume()
        }
//    @IBAction func clickDownloadImage(_ sender: Any) {
//        fetchData()
//        activityIndicator.startAnimating()
//    }
    @IBAction func showImagesCollectionView(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "showImages") as! ShowAllImages
//        vc.imagecacheForCollection = imageToCache
//        vc.tImages = dogImageAllLinks.count
//        vc.title = "image to cache"
//        navigationController?.pushViewController(vc, animated: true)
        guard let viewControl = storyboard?.instantiateViewController(withIdentifier: "showimages") as? ShowAllImages else {
            return
        }

        viewControl.imagecacheForCollection = imageToCache
        viewControl.tImages = dogImageAllLinks.count
        viewControl.title = "image to cache"
        navigationController?.pushViewController(viewControl, animated: true)

    }
}
