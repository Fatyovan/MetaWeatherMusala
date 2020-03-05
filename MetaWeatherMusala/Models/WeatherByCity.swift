//
//  RealmObjects.swift
//  MetaWeatherMusala
//
//  Created by Ivan Jovanovik on 3/4/20.
//  Copyright © 2020 Ivan Jovanovik. All rights reserved.
//

import Foundation
import RealmSwift


class WeatherByCity : Object {
    @objc dynamic var weatherStateIcon : String? = nil
    @objc dynamic var windDirectionCompass : String? = nil
    @objc dynamic var applicableDate : String? = nil
    var temperature = RealmOptional<Int>()
    var maxTemperature = RealmOptional<Int>()
    var minTemperature = RealmOptional<Int>()
    var airPressure = RealmOptional<Float>()
    var humidity = RealmOptional<Float>()
    @objc dynamic var weatherStateName : String? = nil
    var visibility = RealmOptional<Float>()
    var windSpeed = RealmOptional<Float>()
    var id = RealmOptional<Int>()
    var predictability = RealmOptional<Int>()
    var windDirection = RealmOptional<Float>()
    @objc dynamic var cityName : String? = nil
    @objc dynamic var cityId : String? = nil
    
    override static func primaryKey() -> String? {
        return "applicableDate"
    }

    
}

extension WeatherByCity {
       func writeToRealm(){
           try! weatherRealm.write {
            weatherRealm.add(self,update: .modified)
           }
       }
   }
