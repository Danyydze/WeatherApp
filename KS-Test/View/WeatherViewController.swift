//
//  ViewController.swift
//  KS-Test
//
//  Created by Данил Марков on 09.04.2025.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    private let searchTextField = UITextField()
    private let viewModel = WeatherViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        configureSearchTextField()
        configureTableView()
        applyConstraints()
    }
    
    private func configureSearchTextField() {
        searchTextField.placeholder = "Введите город"
        searchTextField.borderStyle = .roundedRect
        searchTextField.textColor = .black
        searchTextField.backgroundColor = .systemGray6
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray2
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(
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
        
        searchTextField.leftView = iconContainer
        searchTextField.leftViewMode = .always
        searchTextField.leftView?.layer.cornerRadius = searchTextField.layer.cornerRadius
        
        view.addSubview(searchTextField)
    }
    
    private func configureTableView() {
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func applyConstraints() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onDataUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        cell.configure(with: viewModel.weatherData[indexPath.row])
        return cell
    }
}

// MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text?.trimmingCharacters(in: .whitespaces), !query.isEmpty else { return true }
        viewModel.searchCity(query)
        textField.resignFirstResponder()
        return true
    }
}
