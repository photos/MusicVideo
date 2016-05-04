//
//  MusicVideoCell.swift
//  MusicVideo
//
//  Created by Forrest Collins on 5/4/16.
//  Copyright © 2016 bananapps. All rights reserved.
//

import UIKit

class MusicVideoCell: UITableViewCell {

    // automatically populate outlets with a public API here not in tableView!
    
    var video: Videos? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var musicImage: UIImageView!
    
    func updateCell() {
        musicTitle.text = video?.vName
        rank.text = "\(video!.vRank)"
        
        //musicImage.image = UIImage(named: "noImg")
        
        if video!.vImageData != nil {
            print("Get data from array...")
            musicImage.image = UIImage(data: video!.vImageData!)
        } else {
            
            getVideoImage(video!, imageView: musicImage)
            print("Get images in background thread")
        }
    }
    
    func getVideoImage(video: Videos, imageView: UIImageView) {
        
        // Background Thread
        //  DISPATCH_QUEUE_PRIORITY_HIGH Items dispatched to the queue will run at high priority, i.e. the queue will be scheduled for execution before any default priority or low priority queue.
        
        //  DISPATCH_QUEUE_PRIORITY_DEFAULT Items dispatched to the queue will run at the default priority, i.e. the queue will be scheduled for execution after all high priority queues have been scheduled, but before any low priority queues have been scheduled.
        
        // DISPATCH_QUEUE_PRIORITY_LOW Items dispatched to the queue will run at low priority, i.e. the queue will be scheduled for execution after all default priority and high priority queues have been scheduled.
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let data = NSData(contentsOfURL: NSURL(string: video.vImageUrl)!)
            
            var image : UIImage?
            if data != nil {
                video.vImageData = data
                image = UIImage(data: data!)
            }
            
            // move back to Main Queue
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
        }
    }
}
