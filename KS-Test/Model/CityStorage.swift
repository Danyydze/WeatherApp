//
//  CityStorage.swift
//  KS-Test
//
//  Created by Данил Марков on 09.04.2025.
//

import Foundation

class CityStorage {
    static let shared = CityStorage()
    private let key = "savedCities"
    
    func saveCities(_ cities: [String]) {
        UserDefaults.standard.set(cities, forKey: key)
    }
    
    func loadCities() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
    
    func addCity(_ city: String) {
        var cities = loadCities()
        if !cities.contains(city) {
            cities.insert(city, at: 0)
            saveCities(cities)
        }
    }
}
