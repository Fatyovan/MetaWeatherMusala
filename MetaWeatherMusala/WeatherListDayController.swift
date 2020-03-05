//
//  WeatherListDayController.swift
//  MetaWeatherMusala
//
//  Created by Ivan Jovanovik on 3/4/20.
//  Copyright © 2020 Ivan Jovanovik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class WeatherListDayController: UIViewController {

    @IBOutlet weak var tablevView: UITableView!
    
    
    var days:[WeatherByCity] {
        get {
            weatherRealm.objects(WeatherByCity.self).compactMap({ $0 }).filter({ $0.cityId == selectedWoeid })
        }
    }
    
    var selectedWoeid:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tablevView.delegate = self
        self.tablevView.dataSource = self
        
        self.getWeatherForCities(location: selectedWoeid)
    }

    func getWeatherForCities(location: String) -> Void {
        
        AF.request("https://www.metaweather.com/api/location/" + location).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                
                for (key, subJson):(String, JSON) in json["consolidated_weather"]{
                    
                    let weatherByDaytoAdd = WeatherByCity()
                    
                    let cityName = json["title"]
                    weatherByDaytoAdd.cityName = cityName.stringValue
                    
                    print(subJson["min_temp"])
                    
                    let weatherStateIcon = subJson["weather_state_abbr"]
                    let windDirectionCompass = subJson["wind_direction_compass"]
                    let applicableDate = subJson["applicable_date"]
                    let temperature = subJson["the_temp"]
                    let maxTemperature = subJson["max_temp"]
                    let minTemperature = subJson["min_temp"]
                    let airPressure = subJson["air_pressure"]
                    let humidity = subJson["humidity"]
                    let weatherStateName = subJson["weather_state_name"]
                    let visibility = subJson["visibility"]
                    let windSpeed = subJson["wind_speed"]
                    let id = subJson["id"]
                    let predictability = subJson["predictability"]
                    let windDirection = subJson["wind_direction"]
                    
                    
                    weatherByDaytoAdd.weatherStateIcon = weatherStateIcon.stringValue
                    weatherByDaytoAdd.windDirectionCompass = windDirectionCompass.stringValue
                    weatherByDaytoAdd.applicableDate = applicableDate.stringValue
                    weatherByDaytoAdd.temperature.value = temperature.intValue
                    weatherByDaytoAdd.maxTemperature.value = maxTemperature.intValue
                    weatherByDaytoAdd.minTemperature.value = minTemperature.intValue
                    weatherByDaytoAdd.airPressure.value = airPressure.floatValue
                    weatherByDaytoAdd.humidity.value = humidity.floatValue
                    weatherByDaytoAdd.weatherStateName = weatherStateName.stringValue
                    weatherByDaytoAdd.visibility.value = visibility.floatValue
                    weatherByDaytoAdd.windSpeed.value = windSpeed.floatValue
                    weatherByDaytoAdd.id.value = id.intValue
                    weatherByDaytoAdd.predictability.value = predictability.intValue
                    weatherByDaytoAdd.windDirection.value = windDirection.floatValue
                    weatherByDaytoAdd.cityId = location
                    
                    
                    weatherByDaytoAdd.writeToRealm()
                }
                                
                DispatchQueue.main.async {
                    self.tablevView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension WeatherListDayController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DaysTableViewCell", for: indexPath) as? DaysTableViewCell {
            let day = days[indexPath.row]
            cell.lblDate.text = day.applicableDate
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    
}

extension WeatherListDayController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let day = days[indexPath.row]
        if let controller = self.storyboard?.instantiateViewController(identifier: "WeatherDetailsViewController") as? WeatherDetailsViewController {
            controller.weatherDetails = day
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
