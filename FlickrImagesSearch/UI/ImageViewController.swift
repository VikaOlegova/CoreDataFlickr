//
//  ImageViewController.swift
//  FlickrImagesSearch
//
//  Created by Вика on 19/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    let imageView: UIImageView
    
    init(image: UIImage) {
        imageView = UIImageView(image: image)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        imageView.frame = self.view.bounds
        imageView.contentMode = .center
        self.view.addSubview(imageView)
    }
}
