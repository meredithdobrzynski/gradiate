//
//  NetworkManager.swift
//  Gradiate
//
//  Created by Fabrice Ulysse on 12/1/18.
//  Copyright © 2018 Gradiate. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

class Network {
    private static let endpoint1 = "http://35.245.237.43/colors/"
    private static let endpoint2 = "http://35.245.237.43/image/"
    private static let endpoint3 = "http://35.245.237.43/images/"
    private static let endpoint4 = "http://35.245.237.43/delete/"

    static func gradiatePictures(image: String, _ completion: @escaping ([Color]) -> Void){

        let parameters: Parameters = [
            "image": image
        ]
        
        Alamofire.request(endpoint1, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseData { (response) in
            switch response.result {
                
            case .success(let data):
                let decoder = JSONDecoder()
                if let colorsResponse = try? decoder.decode(ColorsResponse.self, from: data) {
                    completion(colorsResponse.data)
                }
                
            case .failure(let error):
                print("[Network] Error:", error)
                completion([])
                
            }
        }
        }
    static func uploadGradient(image:String,_ completion: @escaping (() -> (Void))) {
        
        let parameters: Parameters = [
            "base64" : image
        ]
    Alamofire.request(endpoint2, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
    
    switch response.result {
    
    case .success(let json):
        print(json)
        completion()
        
    case .failure(let error):
        print("[Network] Error:", error)
    }
    }
}
    
    static func getGradients(_ completion: @escaping ([Savedimage]) -> Void) {
        
        Alamofire.request(endpoint3, method: .get, encoding: JSONEncoding.default, headers: nil).validate().responseData { (response) in
            
            switch response.result {
                
            case .success(let data):
//                print(data)
                let decoder = JSONDecoder()
                if let gradientResponse = try? decoder.decode(gradientResponse.self, from: data) {
                    completion(gradientResponse.data)
                }

                
            case .failure(let error):
                print("[Network] Error:", error)
            }
        }
    }
    static func deleteGradient(imageIDs: [Int], _ completion: @escaping () -> Void){
        let parameters: Parameters = [
            "array": imageIDs
        ]
        Alamofire.request(endpoint4, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseData { (response) in
            switch response.result{
            case .success(let data):
                print("Success!!!!")
                completion()
            case .failure(let error):
                print("Gradient not found", error)
            }
        }
        }
    }

