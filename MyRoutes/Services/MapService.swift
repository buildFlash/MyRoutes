//
//  MapService.swift
//  MyRoutes
//
//  Created by Aryan Sharma on 19/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import Foundation
import Alamofire

class MapService {
    static let shared = MapService()
    
    private let directionUrl = "https://maps.googleapis.com/maps/api/directions/json?"
    private let nearbyUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    private let photoUrl = "https://maps.googleapis.com/maps/api/place/photo?"
    private let API_KEY = "AIzaSyBMewYCEf5rr3Vw_ZlVwqFkylgbkprUYoQ"
    
    func getDirections(origin: String, destination: String, completionHandler: @escaping (Route) -> ()) {
        let params = ["origin": origin,"destination": destination, "key":API_KEY]
        print(params)
        Alamofire.request(directionUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).response { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            print("Successful")
            guard let data = dataResponse.data else { return }
            do {
                let placeResult = try JSONDecoder().decode(MapDirectionResponse.self, from: data)
                if placeResult.routes.count == 0 {
                    print("No route")
                    let alert = UIAlertController(title: "No Route found", message: "There is no route to this place from your location.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    return
                }
                completionHandler(placeResult.routes[0])
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }

        }
    }
    
    func fetchNearbyResults(location: String, completionHandler: @escaping ([NearbySearchResult]) -> ()) {
        let params = ["key":API_KEY, "location": location, "radius":"10000", "language": "en"]
        Alamofire.request(nearbyUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect ",err)
                return
            }
            guard let data = dataResponse.data else { return }
            do{
                let nearbyResults = try JSONDecoder().decode(Nearby.self, from: data)
                completionHandler(nearbyResults.results)
            } catch let err {
                print("Failed to decode: ", err)
            }
        }
    }
    
    func fetchPhoto(photo: Photo, completionHandler: @escaping (Data) -> ()) {
        let params = ["key":API_KEY, "photoreference":photo.photo_reference!,"maxheight":"100"]
        Alamofire.request(photoUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect ",err)
                return
            }
            guard let data = dataResponse.data else { return }
            completionHandler(data)
        }
    }
    
    struct Nearby: Decodable {
        var results: [NearbySearchResult]
    }
    
    struct NearbySearchResult: Decodable {
        var name: String!
        var vicinity: String!
        var photos: [Photo]!
        var geometry: Location!
    }
    
    struct Location: Decodable {
        var location: Coordinates!
    }
    
    struct Coordinates: Decodable {
        var lat: Double!
        var lng: Double!
    }
    
    struct Photo: Decodable {
        var photo_reference: String!
        var height: Int!
        var width: Int!
    }
    
    struct MapDirectionResponse: Decodable {
        var routes: [Route]!
        var geocoded_waypoints: [GeocodedWaypoint]!
    }
    
    struct GeocodedWaypoint: Decodable {
        var place_id: String!
    }
    
    struct Route: Decodable {
        var overview_polyline: overviewPolyline!
        var legs: [Leg]!
    }
    
    struct overviewPolyline: Decodable {
        var points: String!
    }
    
    struct Leg: Decodable {
        var distance: Text
        var duration: Text
    }
    
    struct Text: Decodable {
        var text: String
    }
}
