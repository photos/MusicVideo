//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by Forrest Collins on 5/4/16.
//  Copyright © 2016 bananapps. All rights reserved.
//

import UIKit

class MusicVideoTVC: UITableViewController {

    var videos = [Videos]()
    
    var limit = 10
    
    var filterSearch = [Videos]()
    
    // nil lets you display search results in same vc
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if swift(>=2.2)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.preferredFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)
            
        #else
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChange", name: UIContentSizeCategoryDidChangeNotification, object: nil)
            
        #endif
        
        reachabilityStatusChanged()
        
    }
    
    func preferredFontChange() {
        print("The preferred font has changed")
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
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        
        title = "The iTunes Top \(limit) Music Videos"
        
        // Setup the search controller
        resultSearchController.searchResultsUpdater = self
        
        // makes sure searchbar doesnt stay on screen if user leaves the view
        definesPresentationContext = true
        
        resultSearchController.dimsBackgroundDuringPresentation = false
        
        resultSearchController.searchBar.placeholder = "Search for Artist, Name, Rank"
        
        resultSearchController.searchBar.searchBarStyle = .Prominent // same as mail, messages look
        
        // add the search bar to the tableview
        tableView.tableHeaderView = resultSearchController.searchBar
        
        tableView.reloadData()
    }
    
    func reachabilityStatusChanged() {
        
        switch reachabilityStatus {
        case NOACCESS :
            //view.backgroundColor = UIColor.redColor()
            // move back to Main Queue
            dispatch_async(dispatch_get_main_queue()) {
                let alert = UIAlertController(title: "No Internet Access", message: "Please make sure you are connected to the Internet", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { action -> () in
                    print("Cancel")
                }
                
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { action -> () in
                    print("Delete")
                }
                
                let okAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
                    print("Ok")
                }
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        default:
            //view.backgroundColor = UIColor.greenColor()
            
            if videos.count > 0 {
                print("do not refresh api")
            } else {
                runAPI()
            }
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        
        self.refreshControl?.endRefreshing()
        
        if resultSearchController.active {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "refresh disabled in search")
        } else {
            runAPI()
        }
    }
    
    
    func getAPICount() {
        if (NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil) {
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            limit = theValue
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDate = formatter.stringFromDate(NSDate())
        
        self.refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDate)")
    }
    
    override func viewDidAppear(animated: Bool) {
        getAPICount()
    }
    
    func runAPI() {
        
        //getAPICount()
        
        // Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
    }
    
    // Remove observer, called just as object is about to be deallocated
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if im in the searchbar
        if resultSearchController.active {
            return filterSearch.count
        }
        
        return videos.count
    }

    private struct storyboard {
        static let cellReuseIdentifier = "Cell"
        static let segueIdentifier = "musicDetail"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! MusicVideoCell

        // if im in the searchbar
        if resultSearchController.active {
            
            cell.video = filterSearch[indexPath.row]
            
        } else {

            // all cell stuff is updated in the cell class didSet
            cell.video = videos[indexPath.row]
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == storyboard.segueIdentifier {
            if let indexpath = tableView.indexPathForSelectedRow {
                
                let video: Videos
                
                // if im in the searchbar
                if resultSearchController.active {
                    video = filterSearch[indexpath.row]
                } else {
                    video = videos[indexpath.row]
                }
                
                let dvc = segue.destinationViewController as! MusicVideoDetailVC
                dvc.videos = video
            }
        }
    }
    
    
    func filterSearch(searchText: String) {
        filterSearch = videos.filter { videos in
            return videos.vArtist.lowercaseString.containsString(searchText.lowercaseString) || videos.vName.lowercaseString.containsString(searchText.lowercaseString) || "\(videos.vRank)".lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
}

extension MusicVideoTVC: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.text!.lowercaseString
        filterSearch(searchController.searchBar.text!)
    }
}
