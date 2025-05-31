//
//  WeatherData.swift
//  KS-Test
//
//  Created by Данил Марков on 09.04.2025.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location?
    let forecast: Forecast?
    let error: WeatherError?
}

struct Location: Codable {
    let name: String
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let tz_id: String?
    let localtime_epoch: Int?
    let localtime: String?
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let date_epoch: Int
    let day: Day
    let astro: Astro?
}

struct Day: Codable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let avgtemp_c: Double
    let maxwind_kph: Double
    let totalprecip_mm: Double?
    let totalsnow_cm: Double?
    let avgvis_km: Double?
    let avghumidity: Double
    let daily_will_it_rain: Int?
    let daily_chance_of_rain: Int?
    let daily_will_it_snow: Int?
    let daily_chance_of_snow: Int?
    let condition: Condition
    let uv: Double?
}

struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int?
}

struct Astro: Codable {
    let sunrise: String?
    let sunset: String?
    let moonrise: String?
    let moonset: String?
    let moon_phase: String?
    let moon_illumination: Int?
    let is_moon_up: Int?
    let is_sun_up: Int?
}

struct WeatherError: Codable {
    let code: Int
    let message: String
}
