//
//  CitiesListTableViewController.swift
//  AirQuality
//
//  Created by Maxwell Poffenbarger on 1/5/21.
//

import UIKit

class CitiesListTableViewController: UITableViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCities()
    }
    
    // MARK: - Properties
    var country: String?
    var state: String?
    var cities: [String] = []
    
    // MARK: - Methods
    func fetchCities() {
        guard let country = country,
              let state = state else { return }
        AirQualityController.fetchSupportedCities(forState: state, inCountry: country) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cities):
                    self.cities = cities
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let cityName = cities[indexPath.row]
        cell.textLabel?.text = cityName
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCityDataVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let country = country,
                  let state = state,
                  let destinationVC = segue.destination as? CityDataViewController else { return }
            let selectCity = cities[indexPath.row]
            destinationVC.city = selectCity
            destinationVC.state = state
            destinationVC.country = country
        }
    }
}//End of class
