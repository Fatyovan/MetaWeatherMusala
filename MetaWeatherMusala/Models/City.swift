//
//  City.swift
//  MetaWeatherMusala
//
//  Created by Ivan Jovanovik on 3/4/20.
//  Copyright © 2020 Ivan Jovanovik. All rights reserved.
//

import Foundation
import RealmSwift

class City : Object{
    @objc dynamic var name = ""
    @objc dynamic var cityId = ""
    
    override static func primaryKey() -> String? {
        return "cityId"
    }

}


extension City {
    func writeToRealm(){
        try! weatherRealm.write {
            weatherRealm.add(self,update: .modified )
        }
    }
}

extension City {
    func deleteFromRealm(){
        try! weatherRealm.write {
            weatherRealm.delete(self)
        }
    }
}
