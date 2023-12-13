//
//  FooterView.swift
//  CollectionView CatInfo Cathing with pagination
//
//  Created by Андрей Соколов on 30.10.2023.
//

import Foundation
import UIKit

class FooterView: UICollectionReusableView {
    
    static let reuseIdentifier = "SectionFooterView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private func setupUI() {
        addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
//            activityIndicator.topAnchor.constraint(equalTo: topAnchor),
//            activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
//            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
//            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func toggleLoading(isEnabled: Bool) {
        if isEnabled {
            activityIndicator.startAnimating()
            print("start")
        } else {
            activityIndicator.stopAnimating()
            print("stop")
        }
    }
}
