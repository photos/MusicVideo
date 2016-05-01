//
//  ViewController.swift
//  MusicVideo
//
//  Created by Forrest Collins on 4/27/16.
//  Copyright © 2016 bananapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var videos = [Videos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
    }
    
    func didLoadData(videos: [Videos]) {
         print(reachabilityStatus)
        self.videos = videos
        
        for item in videos {
            print("name = \(item.vName)")
        }
        
        // get index
        for (index, item) in videos.enumerate() {
            print("\(index) name = \(item.vName)")
        }
    }
}

