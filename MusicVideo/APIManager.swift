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
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(result: (error!.localizedDescription))
                }
                
            } else {
                
                // Added for JSONSerialization
                //print(data)
                do {
                    /* .AllowFragments - top level object is not Array or Dictionary.
                    Any type of string or value
                    NSJSONSerialization requires the Do / Try / Catch
                    Converts the NSData into JSON Object and cast it to a Dictionary */
                    
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject] {
                        
                        print(json)
                        
                        // move back to main queue, set a priority high which means you have a high
                        // priority job that might take time. (priority, 0) means reserved for future
                        // use.
                        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(result: "JSONSerialization Successful")
                            }
                        }
                    }
                } catch {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(result: "error in NSJSONSerialization")
                    }
                }
            }
            // End of JSONSerialization
        }
        task.resume()
    }
    
}