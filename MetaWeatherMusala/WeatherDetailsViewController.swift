//
//  WeatherDetailsViewController.swift
//  MetaWeatherMusala
//
//  Created by Ivan Jovanovik on 3/4/20.
//  Copyright © 2020 Ivan Jovanovik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class WeatherDetailsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var weatherDetails: WeatherByCity!
    
    var weatherByHour:[WeatherByHour] {
        get {
            weatherRealm.objects(WeatherByHour.self).compactMap({ $0 }).filter({ $0.applicableDate == weatherDetails.applicableDate && $0.cityId == weatherDetails.cityId })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViewUrl =   String(format: "https://www.metaweather.com/static/img/weather/png/%@.png", weatherDetails.weatherStateIcon!)
        
        weatherImageView.sd_setImage(with: URL(string: imageViewUrl), placeholderImage: UIImage(named: "placeholder.png"))
        
        if let applicableDate = weatherDetails.applicableDate {
            self.getTempByHours(date: applicableDate)
        }
        
        self.collectionView.dataSource = self
      
    }
    
    func getTempByHours(date:String){
        
        let formatedDate = date.replacingOccurrences(of: "-", with: "/")
        
        AF.request("https://www.metaweather.com/api/location/" + "\(weatherDetails.cityId!)/"  + formatedDate).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                debugPrint(json)
                
                for weatherHour in json.arrayValue {
                    let day = WeatherByHour()
                    day.airPressure.value = weatherHour["air_pressure"].floatValue
                    day.maxTemperature.value = weatherHour["max_temp"].floatValue
                    day.temperature.value = weatherHour["the_temp"].intValue
                    day.humidity.value = weatherHour["humidity"].floatValue
                    day.visibility.value = weatherHour["visibility"].floatValue
                    day.minTemperature.value = weatherHour["min_temp"].floatValue
                    day.created = weatherHour["created"].stringValue
                    day.id = weatherHour["id"].stringValue
                    day.weatherStateAbbr = weatherHour["weather_state_abbr"].stringValue
                    day.windDirectionCompass = weatherHour["wind_direction_compass"].stringValue
                    day.applicableDate  = weatherHour["applicable_date"].stringValue
                    day.cityId = self.weatherDetails.cityId
                    day.writeToRealm()
                                        
                }
                             
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }

}

extension WeatherDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return weatherByHour.count
        print(weatherByHour.count)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HoursWeatherCollectionViewCell", for: indexPath) as! HoursWeatherCollectionViewCell
        let hour = self.weatherByHour[indexPath.item]
        if let temp = hour.temperature.value {
        cell.lblMaxTemp.text = String(temp)
        } else {
            cell.lblMaxTemp.text = ""
        }
        return cell
    }
    
}
