//
//  Weather.swift
//  Weather
//
//  Created by paige on 2022/01/22.
//

import Foundation

struct WeatherResponse: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    
    let temp: Double?
    let humidity: Double?
    
    static var placeholder: Weather {
        return Weather(temp: nil, humidity: nil)
    }
    
}
