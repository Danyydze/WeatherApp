//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Данил Марков on 09.04.2025.
//

import Foundation

class WeatherViewModel {
    
    // MARK: - Constants
    private struct Constants {
        static let networkErrorMessage = "Ошибка сети"
        static let cityNotFoundMessage = "Город не найден"
        static let duplicateCityMessage = "Город '%@' уже добавлен"
    }
    
    // MARK: - Properties
    private let weatherService: WeatherServiceProtocol
    private let cityStorage: CityStorageProtocol
    private(set) var weatherData: [WeatherResponse] = []
    
    // MARK: - Callbacks
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initialization
    init(
        weatherService: WeatherServiceProtocol = WeatherService(),
        cityStorage: CityStorageProtocol = CityStorage.shared
    ) {
        self.weatherService = weatherService
        self.cityStorage = cityStorage
        loadSavedCities()
    }
    
    // MARK: - Public Methods
    func searchCity(_ city: String) {
        let normalizedCity = city
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        guard !normalizedCity.isEmpty else { return }
        
        if isCityAlreadyAdded(normalizedCity) {
            onError?(String(format: Constants.duplicateCityMessage, city))
            return
        }
        
        weatherService.fetchWeather(city: normalizedCity) { [weak self] result in
            self?.handleSearchResult(result, city: normalizedCity)
        }
    }
    
    // MARK: - Private Methods
    private func handleSearchResult(_ result: Result<WeatherResponse, Error>, city: String) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let response):
                self?.handleSuccessResponse(response, city: city)
            case .failure:
                self?.onError?(Constants.networkErrorMessage)
            }
        }
    }
    
    private func handleSuccessResponse(_ response: WeatherResponse, city: String) {
        if response.error != nil {
            onError?(Constants.cityNotFoundMessage)
        } else if response.location != nil {
            cityStorage.addCity(city)
            weatherData.insert(response, at: 0)
            onDataUpdate?()
        }
    }
    
    private func isCityAlreadyAdded(_ city: String) -> Bool {
        weatherData.contains { existingCity in
            existingCity.location?.name.lowercased() == city
        }
    }
    
    private func loadSavedCities() {
        let cities = cityStorage.loadCities()
        cities.forEach { city in
            weatherService.fetchWeather(city: city) { [weak self] result in
                if case .success(let response) = result, response.error == nil {
                    DispatchQueue.main.async {
                        self?.weatherData.append(response)
                        self?.onDataUpdate?()
                    }
                }
            }
        }
    }
}
