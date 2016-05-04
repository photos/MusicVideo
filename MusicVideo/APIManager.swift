//
//  APIManager.swift
//  MusicVideo
//
//  Created by Forrest Collins on 5/1/16.
//  Copyright © 2016 bananapps. All rights reserved.
//

import Foundation

class APIManager {
    
    func loadData(urlString: String, completion: [Videos] -> Void) {
        
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
        let session = NSURLSession(configuration: config)
        
        //let session = NSURLSession.sharedSession()
        
        let url = NSURL(string: urlString)!
        
        let task = session.dataTaskWithURL(url) {
            (data, response, error) -> Void in
            
            if error != nil {
                
                    print(error!.localizedDescription)
                
            } else {
                
                // Added for JSONSerialization
                //print(data)
                do {
                    /* .AllowFragments - top level object is not Array or Dictionary.
                    Any type of string or value
                    NSJSONSerialization requires the Do / Try / Catch
                    Converts the NSData into JSON Object and cast it to a Dictionary */
                    
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? JSONDictionary,
                        feed = json["feed"] as? JSONDictionary,
                        entries = feed["entry"] as? JSONArray {
                        
                        var videos = [Videos]()
                        for (index, entry) in entries.enumerate() {
                            let entry = Videos(data: entry as! JSONDictionary)
                            entry.vRank = index + 1
                            videos.append(entry)
                        }
                        
                        let i = videos.count
                        print("iTunesApiManager - total count --> \(i)")
                        print(" ")

                        // move back to main queue, set a priority high which means you have a high
                        // priority job that might take time. (priority, 0) means reserved for future
                        // use.
                        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(videos)
                            }
                        }
                    }
                } catch {
                    print("error in NSJSONSerialization")
                }
            }
            // End of JSONSerialization
        }
        task.resume()
    }
}