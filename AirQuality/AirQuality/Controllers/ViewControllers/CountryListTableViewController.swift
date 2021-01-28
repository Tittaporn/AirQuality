//
//  CountryListTableViewController.swift
//  AirQuality
//
//  Created by Maxwell Poffenbarger on 1/5/21.
//

import UIKit

class CountryListTableViewController: UITableViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
    }
    
    // MARK: - Properties
    var countries: [String] = []
    
    //MARK: - Actions
    @IBAction func nearestCityButtonTapped(_ sender: Any) {
        // GO TO CityDataViewController By CODING STORYBOARD.ID
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // HAVE TO MATCH The NAME of Storyboard, this case Main.storyboard
        let secondVC = storyboard.instantiateViewController(identifier: "CityDataViewController") //HAVE TO match the Storyboard ID in storyboard
        // The style of presenting
        secondVC.modalPresentationStyle = .pageSheet
        
        // Now Presenting the secondVC ==
        self.present(secondVC, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    func fetchCountries() {
        AirQualityController.fetchSupportedCountries { (result) in
            DispatchQueue.main.async { //For UIView, calling it on the main thread
                switch result {
                case .success(let countries):
                    self.countries = countries
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        let countryName = countries[indexPath.row]
        cell.textLabel?.text = countryName
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStatesVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? StatesListTableViewController else {return}
            let selectedCountry = countries[indexPath.row]
            destinationVC.country = selectedCountry
        }
    }
}//End of class

