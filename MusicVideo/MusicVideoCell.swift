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
        musicImage.image = UIImage(named: "noImg")
    }
}
