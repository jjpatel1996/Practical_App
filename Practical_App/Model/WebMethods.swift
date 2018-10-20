//
//  WebMethods.swift
//  Task2
//
//  Created by Jay Patel on 19/10/18.
//  Copyright © 2018 Jay Patel. All rights reserved.
//

import Foundation
import Alamofire

class WebMethods {
    
    class func getUserList(inputText:String?,nextPageUrlString:String? ,OnCompletion: @escaping ((_ items:[Item],_ nextItemsUrlString:String?) -> Void)) {
        
        var url:URL!
        
        if inputText != nil {
            let encodedText = inputText!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) ?? inputText!
            let urlString = "https://api.github.com/search/users?q=\(encodedText)&per_page=30"
            url = URL(string: urlString)
        }else{
            url = URL(string: nextPageUrlString!)
        }
        
        guard url != nil else {
            OnCompletion([],nil)
            return
        }
        
        Alamofire.request(url!).responseJSON { (response) in
            
           // print("Request: \(String(describing: response.request))")   // original url request
           // print("Response: \(String(describing: response.response))") // http url response
        
            var nextItemsLink:String?
            
            if let links = response.response?.allHeaderFields["Link"]  as? String {
                if links.contains(",") {
                    let linkArray  = links.components(separatedBy: ",")
                    let link = linkArray.filter({ $0.contains("rel=\"next\"") }).first
                    if link != nil {
                        nextItemsLink = link!.components(separatedBy: ";").first!
                        nextItemsLink = nextItemsLink?.trimmingCharacters(in: CharacterSet.whitespaces)
                        nextItemsLink?.removeFirst()
                        nextItemsLink?.removeLast()
                    }
                }else{
                    if links.contains("rel=\"next\"") {
                        nextItemsLink = links.components(separatedBy: ";").first!
                        nextItemsLink = nextItemsLink?.trimmingCharacters(in: CharacterSet.whitespaces)
                        nextItemsLink?.removeFirst()
                        nextItemsLink?.removeLast()
                    }
                }
            }
            print(nextItemsLink ?? "Not found")
            
            if let data = response.data {
                
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(Users.self, from: data)
                    OnCompletion(jsonData.items,nextItemsLink)
                    return
                } catch {
                    print("error:\(error)")
                }
            }
            OnCompletion([],nextItemsLink)
        }
        
    }
    
    
}
