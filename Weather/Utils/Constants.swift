//
//  Constants.swift
//  Weather
//
//  Created by paige on 2022/01/22.
//

import Foundation

struct Constants {
    
    struct URLs {
        
        static func weather(city: String) -> String { "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=your_api_key&units=imperial" }
        // celsius = metric
        
    }
    
}
