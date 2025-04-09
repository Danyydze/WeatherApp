//
//  WeatherTableViewCell.swift
//  KS-Test
//
//  Created by Данил Марков on 09.04.2025.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    private let weatherIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with data: WeatherResponse) {
        cityLabel.text = data.location?.name ?? ""
        timeLabel.text = data.location?.localtime ?? ""
        temperatureLabel.text = "\(data.current?.temp_c ?? 0)°C"
        
        if let iconPath = data.current?.condition.icon {
            let fullURL = "https:" + iconPath
            weatherIcon.sd_setImage(with: URL(string: fullURL))
        }
    }
    
    // MARK: - Layout
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [cityLabel, timeLabel, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        contentView.addSubview(weatherIcon)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            weatherIcon.widthAnchor.constraint(equalToConstant: 40),
            weatherIcon.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: weatherIcon.leadingAnchor, constant: -16)
        ])
    }
}
