//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Forrest Collins on 5/4/16.
//  Copyright © 2016 bananapps. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MusicVideoDetailVC: UIViewController {

    var videos: Videos!
    
    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        title = videos.vArtist
        
        vName.text = videos.vName
        vPrice.text = videos.vPrice
        vRights.text = videos.vRights
        vGenre.text = videos.vGenre
        
        if videos.vImageData != nil {
            videoImage.image = UIImage(data: videos.vImageData!)
        } else {
            // if image is still in background and image isnt received yet
            videoImage.image = UIImage(named: "noImg")
        }
    }
    
    @IBAction func socialMedia(sender: UIBarButtonItem) {
        shareMedia()
    }
    
    func shareMedia() {
        
        // check to see if you authenticated
        let activity1 = "Have you seen this Music Video?"
        let activity2 = "\(videos.vName) by \(videos.vArtist)"
        //let activity3 = "Tell me what you think"
        let activity4 = videos.vLinkToiTunes
        let activity5 = ("Shared with the Music Video App")
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity4, activity5], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if activity == UIActivityTypeMail {
                print("email selected")
            }
        }
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        
        let url = NSURL(string: videos.vVideoUrl)!
        
        let player = AVPlayer(URL: url)
        
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}
