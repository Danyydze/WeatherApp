//
//  SearchTextFieldConfigurator.swift
//  WeatherApp
//
//  Created by User Name on 09.04.2025.
//

import UIKit

struct SearchTextFieldConfigurator {
    
    static func configure(_ textField: UITextField) {
        textField.placeholder = "Введите город"
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.autocorrectionType = .yes
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray2
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите город",
            attributes: placeholderAttributes
        )
        
        let magnifyingGlassImage = UIImage(systemName: "magnifyingglass")?
            .withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
        
        let iconView = UIImageView(image: magnifyingGlassImage)
        iconView.contentMode = .scaleAspectFit
        
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        iconView.frame = CGRect(x: 10, y: 5, width: 20, height: 20)
        iconContainer.addSubview(iconView)
        
        textField.leftView = iconContainer
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
    }
}
