//
//  WeatherViewModel.swift
//  KS-Test
//
//  Created by Данил Марков on 09.04.2025.
//

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
    init(weatherService: WeatherServiceProtocol = WeatherService(),
         cityStorage: CityStorageProtocol = CityStorage.shared) {
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
        DispatchQueue.main.async {
            switch result {
            case .success(let response):
                self.handleSuccessResponse(response, city: city)
            case .failure:
                self.onError?(Constants.networkErrorMessage)
            }
        }
    }
    
    private func handleSuccessResponse(_ response: WeatherResponse, city: String) {
        if response.error != nil {
            self.onError?(Constants.cityNotFoundMessage)
        } else if response.location != nil {
            self.cityStorage.addCity(city)
            self.weatherData.insert(response, at: 0)
            self.onDataUpdate?()
        }
    }
    
    private func loadSavedCities() {
        cityStorage.loadCities().forEach { city in
            weatherService.fetchWeather(city: city) { [weak self] result in
                if case .success(let response) = result, response.error == nil {
                    self?.weatherData.append(response)
                    self?.onDataUpdate?()
                }
            }
        }
    }
}
