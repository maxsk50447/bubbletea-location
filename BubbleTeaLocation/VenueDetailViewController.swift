//
//  VenueDetailViewController.swift
//  BubbleTeaLocation
//
//  Created by Patipol Wangjaitham on 21/2/2562 BE.
//  Copyright © 2562 Patipol Wangjaitham. All rights reserved.
//
import Alamofire
import AlamofireImage
import UIKit

class VenueDetailViewController: UIViewController {

    var name: String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(name)
        nameLabel.text = name
        let img = "https://image.makewebeasy.net/makeweb/0/Ub8wb5z91/MamonDrinks/%E0%B8%8A%E0%B8%B2%E0%B8%99%E0%B8%A1%E0%B9%80%E0%B8%A1%E0%B8%A5%E0%B9%88%E0%B8%AD%E0%B8%99%E0%B9%84%E0%B8%82%E0%B9%88%E0%B8%A1%E0%B8%B8%E0%B8%81_01.jpg"
        Alamofire.request(img)
            .responseImage(completionHandler: { res in
                self.imageView.image = res.result.value
            })
    }
    

}
