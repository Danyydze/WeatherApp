//
//  ServiceProtocols.swift
//  KS-Test
//
//  Created by Данил Марков on 09.04.2025.
//

protocol WeatherServiceProtocol {
    func fetchWeather(city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}

protocol CityStorageProtocol {
    func saveCities(_ cities: [String])
    func loadCities() -> [String]
    func addCity(_ city: String)
    func removeCity(_ city: String)
}
