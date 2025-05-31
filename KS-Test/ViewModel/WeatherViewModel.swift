//
//  WeatherViewModel.swift
//  KS-Test
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
    private(set) var forecastData: [WeatherResponse] = []
    
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
    
    func deleteCity(at index: Int) {
        guard forecastData.indices.contains(index),
              let cityName = forecastData[index].location?.name else { return }
        
        let normalizedCity = cityName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        cityStorage.removeCity(normalizedCity)
        forecastData.remove(at: index)
        DispatchQueue.main.async { [weak self] in
            self?.onDataUpdate?()
        }
    }
    
    func cityName(for section: Int) -> String {
        guard section < forecastData.count else { return "" }
        return forecastData[section].location?.name ?? ""
    }
    
    func dayData(for section: Int, dayIndex: Int) -> ForecastDay? {
        guard section < forecastData.count,
              let days = forecastData[section].forecast?.forecastday,
              dayIndex < days.count else { return nil }
        return days[dayIndex]
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
        } else if response.location != nil && response.forecast != nil {
            cityStorage.addCity(city)
            forecastData.insert(response, at: 0)
            onDataUpdate?()
        }
    }
    
    private func isCityAlreadyAdded(_ city: String) -> Bool {
        forecastData.contains { existingCity in
            existingCity.location?.name.lowercased() == city
        }
    }
    
    private func loadSavedCities() {
        let cities = cityStorage.loadCities()
        cities.forEach { city in
            weatherService.fetchWeather(city: city) { [weak self] result in
                if case .success(let response) = result,
                   response.error == nil,
                   response.location != nil,
                   response.forecast != nil {
                    
                    DispatchQueue.main.async {
                        self?.forecastData.append(response)
                        self?.onDataUpdate?()
                    }
                }
            }
        }
    }
}
