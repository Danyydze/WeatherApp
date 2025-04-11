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
        weatherService.fetchWeather(city: city) { [weak self] result in
            self?.handleSearchResult(result, for: city)
        }
    }
    
    // MARK: - Private Methods
    private func handleSearchResult(_ result: Result<WeatherResponse, Error>, for city: String) {
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
