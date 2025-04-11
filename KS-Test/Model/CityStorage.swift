//
//  CityStorage.swift
//  KS-Test
//
//  Created by Данил Марков on 09.04.2025.
//

import Foundation

class CityStorage: CityStorageProtocol {
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
        let normalizedCity = city
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        if !cities.contains(normalizedCity) {
            cities.insert(normalizedCity, at: 0)
            saveCities(cities)
        }
    }
    
    func removeCity(_ city: String) {
        var cities = loadCities()
        let normalizedInput = city
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        cities.removeAll { existingCity in
            existingCity
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased() == normalizedInput
        }
        
        saveCities(cities)
    }
}
