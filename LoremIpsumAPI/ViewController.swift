//
//  ViewController.swift
//  LoremIpsumAPI
//
//  Created by ARI RODRIGUEZ-CERVANTES on 11/30/18.
//  Copyright © 2018 ARI RODRIGUEZ-CERVANTES. All rights reserved.
//

struct Images: Codable {
    let author: String
    let postUrl: String
    
    enum CodingKeys: String, CodingKey {
        case author
        case postUrl = "post_url"
    }
}

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var UrlTextView: UITextView!
    @IBOutlet weak var UIImageView: UIImageView!
    @IBOutlet weak var AuthorLabel: UILabel!
    
    let jsonUrlString = "https://picsum.photos/list"
    var imageURL = String()
    var author = String()
    var imageArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        parse()
    }
    @IBAction func PictureButton(_ sender: Any) {
        let randomNumber = Int.random(in: 0 ... 992)
        parse(number: randomNumber)
    }
    
    func parse(number: Int){
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url){ (data, response, err) in
            guard let data = data else {return}
            do {
                let images = try JSONDecoder().decode([Images].self, from: data)
                //                print(images)
                for image in images {
                    self.imageArray.append(image.postUrl)
                    self.author = image.author
                    self.imageURL = image.postUrl
//                    print(self.author)
//                    print(self.imageURL)
                }
            } catch let jsonErr {
                print("error serializing data:", jsonErr )
            }
//            print(self.imageArray.count)
//            print(self.imageArray.endIndex)
            print(self.imageArray[number])
            self.imageURL = self.imageArray[number]
            }.resume()
        
        UrlTextView.text = imageURL
        downloadImage(from: <#T##URL#>)
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    
}

