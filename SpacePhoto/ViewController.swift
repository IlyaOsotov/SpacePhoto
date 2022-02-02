//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Илья Осотов on 01.02.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet var photoView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    @IBOutlet var webView: WKWebView!
    
    let photoInfoController = PhotoInfoController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        photoView.image = UIImage(systemName: "photo.on.rectangle")
        descriptionLabel.text = ""
        copyrightLabel.text = ""
                
        photoInfoController.fetchPhotoInfo { (result) in
            switch result {
            case .success(let photoInfo):
                self.updateUI(with: photoInfo)
            case .failure(let error):
                self.updateUI(with: error)
            }
        }
    }
    
    func updateUI(with photoInfo: PhotoInfo) {
        photoInfoController.fetchImage(from: photoInfo.url) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.webView.isHidden = true
                    self.title = photoInfo.title

                    self.photoView.image = image
                    self.descriptionLabel.text = photoInfo.description
                    self.copyrightLabel.text = photoInfo.copyright
                case .failure(let error):
                    if photoInfo.url.absoluteString.contains("youtube") {
                        self.updateUI(with: photoInfo, videoURL: photoInfo.url)
                    } else {
                        self.updateUI(with: error)
                    }
                }
            }
        }
    }
    
    func updateUI(with photoInfo: PhotoInfo, videoURL: URL) {
        self.photoView.isHidden = true
        self.title = photoInfo.title
        self.descriptionLabel.text = photoInfo.description
        self.copyrightLabel.text = photoInfo.copyright
        
        let myRequest = URLRequest(url: videoURL)
        self.webView.load(myRequest)
    }
    
    func updateUI(with error: Error) {
        title = "Error fetching photo"
        photoView.image = UIImage(systemName: "exclamationmark.octagon")
        descriptionLabel.text = error.localizedDescription
        copyrightLabel.text = ""
    }

}

