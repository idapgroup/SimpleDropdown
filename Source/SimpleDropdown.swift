//
//  SimpleDropdown.swift
//
//  Created by Filipp Kosenko on 03.09.2024.
//  Copyright © 2024 IDAP. All rights reserved.
//

import UIKit

class DropdownView: UIView, UITableViewDelegate, UITableViewDataSource {

    // MARK: -
    // MARK: Variables
    
    public var headerConfigurator: ((UIView, String) -> Void)?
    public var cellConfigurator: ((UITableViewCell, String) -> Void)?
    
    private var options: [String] = []
    private var defaultViewPlaceHolder: String
    private var buttonColor: UIColor = .white
    private var currentOption: String {
        didSet {
            if let configurator = self.headerConfigurator {
                configurator(self.customHeaderView ?? self.button, self.currentOption)
            }
        }
    }
    private var customHeaderView: UIView?
    private var customCellType: UITableViewCell.Type?
    private var customCellIdentifier: String?
    private var tableViewHeight: CGFloat?
    private var isDropdownOpen = false

    private let button = UIButton(type: .system)
    private let tableView = UITableView()

    // MARK: -
    // MARK: Init
    
    public init(options: [String], defaultViewPlaceHolder: String? = "Click to select", tableViewHeight: CGFloat? = nil, customCellType: UITableViewCell.Type? = nil, customCellIdentifier: String? = nil, customHeaderView: UIView? = nil) {
        self.defaultViewPlaceHolder = defaultViewPlaceHolder ?? "Click to select"
        self.currentOption = self.defaultViewPlaceHolder
        self.customCellType = customCellType
        self.customCellIdentifier = customCellIdentifier
        self.customHeaderView = customHeaderView
        self.tableViewHeight = tableViewHeight
        
        super.init(frame: CGRect())
        
        self.options = options
        self.prepareView()
    }
    
    required init?(coder: NSCoder) {
        self.defaultViewPlaceHolder = "Click to select"
        self.currentOption = self.defaultViewPlaceHolder
        self.tableViewHeight = self.tableViewHeight ?? nil
        
        super.init(coder: coder)
        
        self.prepareView()
    }
    
    // MARK: -
    // MARK: Public
    
    public func updateCurrentOption(option: String) {
        self.currentOption = option
    }
    
    // MARK: -
    // MARK: Private
    
    private func prepareView() {
        if let customHeaderView = self.customHeaderView {
            self.prepareCustomHeader(view: customHeaderView)
        } else {
            self.prepareDefaultHeader()
        }
        self.prepareTableView()
    }
    
    private func prepareCustomHeader(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleDropdown))
        view.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func prepareDefaultHeader() {
        self.button.setTitle(self.defaultViewPlaceHolder, for: .normal)
        self.button.backgroundColor = self.buttonColor
        self.button.addTarget(self, action: #selector(self.toggleDropdown), for: .touchUpInside)
        addSubview(self.button)
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.button.topAnchor.constraint(equalTo: self.topAnchor),
            self.button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func prepareTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isHidden = true
        self.tableView.layer.borderWidth = 1
        self.tableView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let customCellType = self.customCellType, let customCellIdentifier = self.customCellIdentifier {
            self.tableView.register(customCellType, forCellReuseIdentifier: customCellIdentifier)
        } else {
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        }
    }
    
    @objc private func toggleDropdown() {
        self.isDropdownOpen.toggle()
        
        if self.isDropdownOpen {
            self.showDropdown()
        } else {
            self.hideDropdown()
        }
    }
    
    private func showDropdown() {
        guard let window = self.window else { return }
        
        let buttonFrame = self.convert(self.bounds, to: window)
        let tableHeight = self.tableViewHeight ?? CGFloat(min(self.options.count, 5)) * 44.0
        
        self.tableView.frame = CGRect(
            x: buttonFrame.origin.x,
            y: buttonFrame.origin.y + buttonFrame.height,
            width: buttonFrame.width,
            height: tableHeight
        )
        window.addSubview(self.tableView)
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    private func hideDropdown() {
        self.tableView.removeFromSuperview()
    }
    
    // MARK: -
    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = self.customCellIdentifier ?? "defaultCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
         
        let option = self.options[indexPath.row]
        if let configurator = self.cellConfigurator {
            configurator(cell, option)
        } else {
            cell.textLabel?.text = option
        }
         
        return cell
     }
    
    // MARK: -
    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = self.options[indexPath.row]
        if let configurator = self.headerConfigurator {
            configurator(self.customHeaderView ?? self.button, selectedOption)
        } else {
            self.button.setTitle(selectedOption, for: .normal)
        }
        self.currentOption = selectedOption
        
        self.toggleDropdown()
    }
}
