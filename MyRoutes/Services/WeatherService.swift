//
//  WeatherService.swift
//  MyRoutes
//
//  Created by Aryan Sharma on 19/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import Foundation
import Alamofire

class WeatherService {
    static let shared = WeatherService()
    
    private let baseUrl = "https://api.forecast.io/forecast/0223b6433abb824702ceb9e95b7a0095/"
    
    func getWeatherDetails(location: String, completionHandler: @escaping (CurrentWeather) -> ()) {
        let url = baseUrl + location
        Alamofire.request(url).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }

            guard let data = dataResponse.data else { return }
            
            do{
                let weatherResult = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completionHandler(weatherResult.currently)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }
            
        }
    }
    
    struct WeatherResponse: Decodable {
        var currently: CurrentWeather!
    }
    
    struct CurrentWeather: Decodable {
        var icon: String!
        var summary: String!
        var temperature: Double!
        var precipProbability: Double!
        var apparentTemperature: Double!
        var humidity: Double!
    }
}
