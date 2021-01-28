//
//  AirQualityController.swift
//  AirQuality
//
//  Created by Lee McCormick on 1/28/21.
//

import Foundation

class AirQualityController {
    
    // MARK: - String Constants
    static let baseURL = URL(string: "https://api.airvisual.com/") //appendingPathcomponent knows if you have / or not have it, it will help add one if you don't have it.
    static let version = "v2"
    static let countryComponent = "countries"
    static let stateComponent = "states"
    static let cityComponent = "cities"
    static let cityDataComponent = "city"
    static let apiKey = "8bdce532-a7f5-49ac-b1d3-742af42b3bc2"
    static let nearestCityComponent = "nearest_city"
    
    // MARK: - Fetch Supported Countries
    // We are getting back Array String of Many Country >> it is not on the model.
    // static using static func because we are using the shareInstance
    static func fetchSupportedCountries(then completion: @escaping (Result<[String],NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(version)
        let countryURL = versionURL.appendingPathComponent(countryComponent)
        var components = URLComponents(url: countryURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        components?.queryItems = [apiQuery]
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        // http://api.airvisual.com/v2/countries?key=8bdce532-a7f5-49ac-b1d3-742af42b3bc2
        
        // NOW WE ARE USING response
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                // DON NOT NEED TO PRINT ERROR BECAUSE we don't want to redundant from (.thrownError(error))).
                return completion(.failure(.thrownError(error)))
            }
            
            // HERE IS THE response, we are always get the response from api
            if let response = response as? HTTPURLResponse {
                print("COUNTRY LIST STATUS CODE: \(response.statusCode)")
                // NEVER PUT return HERE because it will return out of the function.
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(Country.self, from: data)
                let countryDictionaries = topLevelObject.data
                var listOfCountryNames: [String] = []
                
                for countryDict in countryDictionaries {
                    let countryName = countryDict.countryName
                    listOfCountryNames.append(countryName)
                }
                return completion(.success(listOfCountryNames)) //return HERE >> Max Style SO WE CAN RETURN completion(.success(listOfCountryNames))
            } catch {
                completion(.failure(.thrownError(error)))
            }//Then in the catch just completion with error, no redundant
        }.resume() //DO NOT FORGET .resume() ALWAYS PUT IT.
    } //End of func
    
    // MARK: - Fetch Supported States
    static func fetchSupportedStates(forCountry: String, then completion: @escaping (Result<[String],NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(version)
        let statesURL = versionURL.appendingPathComponent(stateComponent)
        
        var components = URLComponents(url: statesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        let countryQuery = URLQueryItem(name: "country", value: forCountry)
        components?.queryItems = [apiQuery, countryQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        // http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key=8bdce532-a7f5-49ac-b1d3-742af42b3bc2
        // For example `forCountry == "thailand"`
        // http://api.airvisual.com/v2/states?country=thailand&key=8bdce532-a7f5-49ac-b1d3-742af42b3bc2
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("STATE LIST STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            do {
                let topLevelObject = try JSONDecoder().decode(State.self, from: data)
                let stateDictionaries = topLevelObject.data
                var listOfStateNames: [String] = []
                
                for stateDict in stateDictionaries {
                    let stateName = stateDict.stateName
                    listOfStateNames.append(stateName)
                }
                return completion(.success(listOfStateNames))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    } //End of func
    
    // MARK: - Fetch Supported Cities
    static func fetchSupportedCities(forState: String, inCountry: String, then completion: @escaping (Result<[String], NetworkError>) -> Void){
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(version)
        let citiesURL = versionURL.appendingPathComponent(cityComponent)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        let countryQuery = URLQueryItem(name: "country", value: inCountry)
        let stateQuery = URLQueryItem(name: "state", value: forState)
        components?.queryItems = [stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        //  http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
        // For example `forState == "illinois", inCountry == "usa"`
        //http://api.airvisual.com/v2/cities?state=illinois&country=usa&key=8bdce532-a7f5-49ac-b1d3-742af42b3bc2
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("CITY LIST STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(City.self, from: data)
                let cityDictionaries = topLevelObject.data
                var listOfCityNames: [String] = []
                
                for cityDict in cityDictionaries {
                    let cityName = cityDict.cityName
                    listOfCityNames.append(cityName)
                }
                return completion(.success(listOfCityNames))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    } //End of func
    
    // MARK: - Fetch City Data
    static func fetchCityData(forCity: String, inState: String, inCountry: String, then completion: @escaping (Result<CityData, NetworkError>)-> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(version)
        let citiesURL = versionURL.appendingPathComponent(cityDataComponent)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        let countryQuery = URLQueryItem(name: "country", value: inCountry)
        let stateQuery = URLQueryItem(name: "state", value: inState)
        let cityQuery = URLQueryItem(name: "city", value: forCity)
        components?.queryItems = [cityQuery, stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        
        // For example `forCity == "", inState == "Kabul", inCountry == "Afghanistan"` https://api.airvisual.com/v2/city?city=Kabul&state=Kabul&country=Afghanistan&key=8bdce532-a7f5-49ac-b1d3-742af42b3bc2
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("CITY DATA STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do {
                //LEEBACK if it is broken.
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                return completion(.success(cityData))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }//End of func
    
    // MARK: - Fetch Nearest City
    static func fetchNearestCity(then completion: @escaping (Result<CityData, NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(version)
        let nearestCityURL = versionURL.appendingPathComponent(nearestCityComponent)
        
        var componants = URLComponents(url: nearestCityURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        componants?.queryItems = [apiQuery]
        guard let finalURL = componants?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        // http://api.airvisual.com/v2/nearest_city?key=8bdce532-a7f5-49ac-b1d3-742af42b3bc2
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("NEAREST CITY DATA STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            do {
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                return completion(.success(cityData))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    } //End of function
} //End of class


/* NOTE
 API FROM https://www.iqair.com/us/dashboard
 
 GET List supported countries
 http://api.airvisual.com/v2/countries?key={{YOUR_API_KEY}}
  
 GET List supported states in a country
 http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
 
 GET List supported cities in a state
 http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
 
 GET Get specified city data
 http://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
 
 GET Get nearest city data (IP geolocation)
 http://api.airvisual.com/v2/nearest_city?key={{YOUR_API_KEY}}
 
 */
