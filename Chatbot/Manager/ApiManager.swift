//
//  ApiManager.swift
//  Chatbot
//
//  Created by Khusboo Singh on 06/08/23.
//

import Foundation

class ApiManager: NSObject , URLSessionDelegate {
    
    static let instance = ApiManager()
    
    /** This method is used to GET request web serice */
    func callWebServiceMethodCallWithParameterDictionary(urlString:String, headerDictionary:NSDictionary?, bodyDictionary:NSDictionary?,requestType:String, sucessHandler : @escaping (Data)->Void, failuerHandler : @escaping (AnyObject)->Void)  {
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url:url!)
        request.httpMethod = requestType
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let headerDictionary = headerDictionary {
            request.allHTTPHeaderFields = headerDictionary as? [String:String]
        }
        
        if bodyDictionary != nil {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyDictionary ?? ["":""], options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        let task = self.sessionConfiguration().dataTask(with: request as URLRequest) { (data, response, error) in
            
            if (error == nil){
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200 {
                    do{
                        let responseData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        if let JSONString = String(data: data!, encoding: String.Encoding.utf8) {
                        }
                        let responseDictionary = responseData as! NSDictionary
                        
                        if let status = responseDictionary["statuscode"] {
                            if status as? Int == 200 {
                                sucessHandler(data!)
                            }
                        }
                        
                    }catch{
                        failuerHandler("Something went wrong" as AnyObject)
                    }
                }else{
                    failuerHandler("Something went wrong" as AnyObject)
                }
            }else{
                failuerHandler(error?.localizedDescription as AnyObject)
            }
        }
        task.resume()
    }
    
    /** This method is used to create URL session */
    func sessionConfiguration() -> URLSession {
        let config = URLSessionConfiguration.default
        return  URLSession(configuration: config)
    }

}
