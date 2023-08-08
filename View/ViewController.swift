//
//  ViewController.swift
//  MVVM using Binding
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var tableViewUserData: UITableView!
    var showimages: ShowAllImages?
    var dogallData: DogData?
    var dogImageAllLinks = [String]()
    private let imageCacheQueue = DispatchQueue(label: "com.example.imageCacheQueue")

    var imageToCache = NSCache<NSString, UIImage>()
     private let viewModel = UserViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
       fetchData()
       setupinitialview()
        viewbind()
      viewModel.getUserData()
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
            // Calculate the totalImages
            let totalImages = self.dogImageAllLinks.count
            var imgdata = 0
            var totalDownloadImage: Int = 0
            while imgdata < totalImages {
                let urlString = URL(string: self.dogImageAllLinks[imgdata])
                self.downloadImage(from: urlString!, counter: String(imgdata), completion: { value  in
                    if value == 1 {
                        totalDownloadImage += 1
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
                completion(0)
                return
            }
            let localImageToCache = self.imageToCache
            self.imageCacheQueue.async {
                self.imageToCache.setObject(image, forKey: NSString(string: counter))
            }

            completion(1)
        })
        dataTask.resume()
        }
    @IBAction func addData(_ sender: Any) {
guard let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "DepartmentViewController") as? DepartmentViewController
           else {
             return
         }
        self.navigationController?.pushViewController(secondVC, animated: true)

    }
    @IBAction func showImages(_ sender: Any) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "showimages") as? ShowAllImages else {
            return
        }

        viewController.imagecacheForCollection = imageToCache
        viewController.tImages = dogImageAllLinks.count
        viewController.title = "image to cache"
        navigationController?.pushViewController(viewController, animated: true)

    }
func setupinitialview() {
        tableViewUserData.dataSource = self
        tableViewUserData.delegate = self
    }
    func viewbind() {
        viewModel.usersCellDataSource.bind {_ in
            DispatchQueue.main.async {
                self.tableViewUserData.reloadData()
            }
            }
        }
}
extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.usersCellDataSource.value?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserdataTableViewCell", for: indexPath)
            as? UserdataTableViewCell else {
            return UITableViewCell()
        }
        guard  let userObject = viewModel.usersCellDataSource.value?[indexPath.row]
        else {
          return cell
      }
        cell.labelname.text = userObject.name
        cell.labelEmail.text = userObject.email
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
 func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        let alert = UIAlertController(title: "Confirmation", message:
                                        "Are you sure you want to delete this item?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.usersCellDataSource.value?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        }
 }
}
