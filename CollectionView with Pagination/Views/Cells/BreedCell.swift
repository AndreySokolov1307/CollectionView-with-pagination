//
//  CatCollectionViewCell.swift
//  CollectionView CatInfo Cathing with pagination
//
//  Created by Андрей Соколов on 28.10.2023.
//

import UIKit

class BreedCell: UICollectionViewCell {
    
    static let reuseIdentifier = "BreedCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var catImage: UIImage? {
        didSet {
            imageView.image = catImage
            activityIndicator.stopAnimating()
        }
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let breedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor.label
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private func setupCellUI() {
        contentView.backgroundColor = .systemGroupedBackground
        addSubview(stackView)
        stackView.addArrangedSubview(breedLabel)
        stackView.addArrangedSubview(imageView)
        imageView.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: imageView.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
}

//TODO: - сделать чтобы загружало ебаную картинку сука
@MainActor
extension BreedCell {
    func configure(for breed: Breed, breedController: BreedController) async {
        breedLabel.text = breed.name
        
//        guard let imageID = breed.referenceImageID,
//              let url = try? await breedController.fetchImageURL(fromID: imageID),
//              let image = try? await breedController.fetchImage(from: url) else {
//            return
//        }
        
        guard let imageID = breed.referenceImageID else {
            imageView.image = UIImage(systemName: "photo")
            return
        }
        
        do {
            let url = try await breedController.fetchImageURL(fromID: imageID)
            let image = try await breedController.fetchImage(from: url!)
            catImage = image
        } catch {
            print("Error fetchig image \(error)")
        }
    }
    
    func configureForPagination(with paginationBreed: PaginationBreed) async {
        breedLabel.text = paginationBreed.breeds[0].name
        
        do {
            guard let url = URL(string: paginationBreed.url) else {
                return
            }
            let image = try await PaginationController.shared.fetchImage(from: url)
            catImage = image
        } catch {
            print("Error fetchig image \(error)")
        }
    }
}
