//
//  ViewController.swift
//  MetaWeatherMusala
//
//  Created by Ivan Jovanovik on 3/4/20.
//  Copyright © 2020 Ivan Jovanovik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var cities:[City] {
        get {
            weatherRealm.objects(City.self).compactMap({ $0 })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // This will execute on first run of application or delete all woeids
        if  cities.count == 0 {
            let cities : [String: String] = [ "839722": "Sofia" , "2459115" :"NY" ,"1118370": "Tokyo" ]
            for (key,value) in cities {
                let city = City()
                city.name = value
                city.cityId = key
                
                if let foundCity = weatherRealm.object(ofType: City.self, forPrimaryKey: key) {
                    debugPrint(foundCity)
                }
                else {
                    city.writeToRealm()
                }
            }
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let addNewCity = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTappedNewCity))
        self.navigationItem.rightBarButtonItem  = addNewCity
        
    }
    
    @objc func addTappedNewCity() {
        let alertController = UIAlertController(title: "Plaase Add New City", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            print("New Add City: \(String(describing: textField.text))")
            if let cityName = textField.text {
                self.addNewCity(cityName: cityName)

            }
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func addNewCity(cityName:String) {
        let newCity = String(format: "https://www.metaweather.com/api/location/search/?query=%@", cityName)
        AF.request(newCity).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let city = City()
                city.name = json.array?.first?["title"].stringValue ?? ""
                city.cityId = json.array?.first?["woeid"].stringValue ?? ""
                
                if let foundCity = weatherRealm.object(ofType: City.self, forPrimaryKey: city.cityId) {
                    debugPrint(foundCity)
                }
                else if city.cityId.count > 0 {
                    city.writeToRealm()
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                debugPrint(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        if let viewCOntroller = self.storyboard?.instantiateViewController(withIdentifier: "WeatherListDayController") as? WeatherListDayController {
            viewCOntroller.selectedWoeid = city.cityId
            self.navigationController?.pushViewController(viewCOntroller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
        let city = cities[indexPath.row]
        city.deleteFromRealm()
        tableView.deleteRows(at: [indexPath], with: .fade)
     }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as? CityTableViewCell {
            let city = cities[indexPath.row]
            cell.cityNameLbl.text = city.name
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
}


