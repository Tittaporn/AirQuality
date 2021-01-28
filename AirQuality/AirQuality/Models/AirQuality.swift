//
//  AirQuality.swift
//  AirQuality
//
//  Created by Lee McCormick on 1/28/21.
//

import Foundation

// MARK: - Country List
struct Country: Codable {
    let status: String
    let data: [Data]
    
    struct Data: Codable {
        let countryName: String
        
        enum CodingKeys: String, CodingKey { // Using Coding Key needs to be exactly like this line and inside the struct. // For translating from JSON to English
            case countryName = "country"
        }
    }
}

// MARK: - State List
struct State: Codable {
    let status: String
    let data: [Data]
    
    struct Data: Codable {
        let stateName: String
        // let idk: String
        
        enum CodingKeys: String, CodingKey { // Using Coding Key needs to be exactly like this line and inside the struct. // For translating from JSON to English
            case stateName = "state"
            // case idk >> Every properties on the struct need all casse here, bu don't need to named all of it.
        }
    }
}

// MARK: - City List
struct City: Codable {
    let status: String
    let data: [Data]
    
    struct Data: Codable {
        let cityName: String
        
        enum CodingKeys: String, CodingKey {
            case cityName = "city"
        }
    }
}

// MARK: - City Data
struct CityData: Codable {
    let status: String
    let data: Data
    
    struct Data: Codable {
        let city: String
        let state: String
        let country: String
        let location: Location
        let current: Current
        
        struct Location: Codable {
            let coordinates: [Double]
        }
        
        struct Current: Codable {
            let weather: Weather
            let pollution: Pollution
            
            struct Weather: Codable {
                let tp: Int
                let hu: Int
                let ws: Double
            }
            struct Pollution: Codable {
                let aqius: Int
            }
        }
        
    }
}

