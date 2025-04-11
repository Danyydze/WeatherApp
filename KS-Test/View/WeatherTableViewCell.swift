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
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
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
        iv.clipsToBounds = true
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
            loadImage(from: "https:" + iconPath)
        }
    }
    
    // MARK: - Image Loading
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self.weatherIcon.image = image
            }
        }.resume()
    }
    
    // MARK: - Layout
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [cityLabel, timeLabel, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        
        contentView.addSubview(stackView)
        contentView.addSubview(weatherIcon)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            weatherIcon.widthAnchor.constraint(equalToConstant: 50),
            weatherIcon.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            weatherIcon.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            weatherIcon.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
