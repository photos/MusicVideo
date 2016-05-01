//
//  APIManager.swift
//  MusicVideo
//
//  Created by Forrest Collins on 5/1/16.
//  Copyright © 2016 bananapps. All rights reserved.
//

import Foundation

class APIManager {
    
    
    func loadData(urlString: String, completion: (result: String) -> Void) {
        
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
        let session = NSURLSession(configuration: config)
        
        //let session = NSURLSession.sharedSession()
        
        let url = NSURL(string: urlString)!
        
        let task = session.dataTaskWithURL(url) {
            (data, response, error) -> Void in
            
            // bring everything from background to main thread
            dispatch_async(dispatch_get_main_queue()) {
                
                if error != nil {
                    // explain why the operation failed
                    completion(result: (error!.localizedDescription))
                } else {
                    // success
                    completion(result: "NSURLSession successful")
                    print(data!)
                }
            }
        }
        
        // have to do task.resume or the task will never execute
        task.resume()
    }
    
}