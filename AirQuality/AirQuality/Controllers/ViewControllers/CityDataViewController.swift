//
//  CityDataViewController.swift
//  AirQuality
//
//  Created by Maxwell Poffenbarger on 1/5/21.
//

import UIKit

class CityDataViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var closestCityTitleLabel: UILabel!
    @IBOutlet weak var cityStateCountryLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    
    // MARK: - Properties
    var city: String?
    var state: String?
    var country: String?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        closestCityTitleLabel.isHidden = true //Hide it for closest city.
        fetchCityData()
    }
    
    // MARK: - Methods
    func fetchCityData() {
        if let city = city, let state = state, let country = country {
            // if we have value fetch the city
            AirQualityController.fetchCityData(forCity: city, inState: state, inCountry: country) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let cityData):
                        self.updateViews(with: cityData)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            // if we DO NOT have value fetch the nearest city instead.
            fetchNearestCity()
        }
    }
    
    func updateViews(with cityData: CityData) {
        cityStateCountryLabel.text = "\(cityData.data.city), \(cityData.data.state) \n\(cityData.data.country)"
        aqiLabel.text = "AQI: \(cityData.data.current.pollution.aqius)"
        windspeedLabel.text = "Windspeed: \(cityData.data.current.weather.ws)"
        temperatureLabel.text = "Temperature \(cityData.data.current.weather.tp)"
        humidityLabel.text = "Humidity: \(cityData.data.current.weather.hu)"
        
        if cityData.data.location.coordinates.count == 2 {
            latLongLabel.text = "Latitude: \(cityData.data.location.coordinates[1]) \nLongitude: \(cityData.data.location.coordinates[0])"
        } else {
            latLongLabel.text = "Coordinates: Center of the earth."
        }
    }
    
    func fetchNearestCity() {
        AirQualityController.fetchNearestCity { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityData):
                    self.updateViews(with: cityData)
                    self.closestCityTitleLabel.isHidden = false
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}//End of class
