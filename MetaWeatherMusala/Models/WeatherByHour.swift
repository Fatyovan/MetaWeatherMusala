//
//  WeatherByHour.swift
//  MetaWeatherMusala
//
//  Created by Ivan Jovanovik on 3/4/20.
//  Copyright © 2020 Ivan Jovanovik. All rights reserved.
//

import Foundation
import RealmSwift


class WeatherByHour : Object {
    
    @objc dynamic var windDirectionCompass : String? = nil
    var temperature = RealmOptional<Int>()
    @objc dynamic var id : String? = nil
    var windDirection = RealmOptional<Float>()
    var minTemperature = RealmOptional<Float>()
    var maxTemperature = RealmOptional<Float>()
    var predictability = RealmOptional<Int>()
    var windSpeed = RealmOptional<Float>()
    var humidity = RealmOptional<Float>()
    var visibility = RealmOptional<Float>()
    @objc dynamic var applicableDate : String? = nil
    @objc dynamic var weatherStateAbbr : String? = nil
    var airPressure = RealmOptional<Float>()
    @objc dynamic var weatherStateName : String? = nil
    @objc dynamic var created : String? =  nil
    @objc dynamic var cityId : String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension WeatherByHour {
    func writeToRealm(){
        try! weatherRealm.write {
            weatherRealm.add(self,update: .modified)
        }
    }
}
