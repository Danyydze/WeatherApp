//
//  WeatherService.swift
//  KS-Test
//
//  Created by Данил Марков on 09.04.2025.
//

import Foundation

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "007417819d6548faa75173435250904"
    
    func fetchWeather(city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(encodedCity)&days=5"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
