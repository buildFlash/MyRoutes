//
//  APIService.swift
//  MyRoutes
//
//  Created by Aryan Sharma on 19/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseAuth

class APIService {
    
    let baseUrl = "https://us-central1-myroutes-1521442171174.cloudfunctions.net/"
    static let shared = APIService()
    
    //MARK:- PlacesTVC
    
    func fetchPlaces(completionHandler: @escaping ([Place]) -> ()) {
        let url = baseUrl + "getPlaces"
        let parameters = ["uid": (Auth.auth().currentUser?.uid)! ]
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                let placeResult = try JSONDecoder().decode(PlacesResult.self, from: data)
                completionHandler(placeResult.places)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }
        }
    }
    
    
    //MARK:- Structs
    
    struct PlacesResult: Decodable {
        var isEmpty: Bool
        var places: [Place]!
    }
    
}
