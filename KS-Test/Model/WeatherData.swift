//
//  Model.swift
//  KS-Test
//
//  Created by Данил Марков on 09.04.2025.
//

struct WeatherResponse: Codable {
    let location: Location?
    let current: Current?
    let error: WeatherError?
}

struct Location: Codable {
    let name: String
    let localtime: String
}

struct Current: Codable {
    let temp_c: Double
    let condition: Condition
}

struct Condition: Codable {
    let text: String
    let icon: String
}

struct WeatherError: Codable {
    let message: String
}
