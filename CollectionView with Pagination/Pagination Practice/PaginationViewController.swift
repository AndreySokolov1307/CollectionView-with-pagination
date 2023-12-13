//
//  PaginationViewController.swift
//  CollectionView CatInfo Cathing with pagination
//
//  Created by Андрей Соколов on 31.10.2023.
//

import UIKit
import SafariServices

class PaginationViewController: UIViewController {
    
    private let apiKey = "live_PTv2j5mgtAGsSJVgHEzPbYb5KRdp4ZCwQN1VESak4DA5Phg6A9HcP0BNrNWdiANR"

    private let breedView = BreedView()
    
    private var paginationBreeds = [PaginationBreed]() {
        didSet {
            isPaginating = false
            print("did Set")
        }
    }
    private var page = 0
    private var isPaginating = false
    private lazy var query = [
        "limit": "10",
        "page": String(page),
        "has_breeds": "1",
        "api_key" : apiKey
    ]
    
    private var dataSource: UICollectionViewDiffableDataSource<String, PaginationBreed>! = nil
    private var snapshot: NSDiffableDataSourceSnapshot<String, PaginationBreed> {
        
        var snapshot = NSDiffableDataSourceSnapshot<String, PaginationBreed>()
        snapshot.appendSections(["Results"])
        snapshot.appendItems(paginationBreeds)
        return snapshot
    }
    
    override func loadView() {
        self.view = breedView
        breedView.collectionView.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breedView.collectionView.register(BreedCell.self, forCellWithReuseIdentifier: BreedCell.reuseIdentifier)
        breedView.collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.reuseIdentifier)
        
        breedView.collectionView.delegate = self
        fetchBreeds(atPage: page)
        congifureCollectionViewDataSource()
    }
    
    private func fetchBreeds(atPage page: Int) {
        
        Task {
            do {
                self.paginationBreeds = try await PaginationController.shared.fetchBreeds(matching: query)
            } catch {
                print(error)
            }
            await dataSource.apply(snapshot, animatingDifferences: true)
        }
        self.page += 1
    }
    
    private func congifureCollectionViewDataSource()  {
        dataSource = UICollectionViewDiffableDataSource<String, PaginationBreed>(collectionView: breedView.collectionView, cellProvider: {(collectionView, indexPath, breed) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedCell.reuseIdentifier, for: indexPath) as! BreedCell
            
            Task {
                await cell.configureForPagination(with: breed)
            }
            
            return cell
        })
        
        //MARK: - SupplementaryViewProvider
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.reuseIdentifier, for: indexPath) as! FooterView
        print("Footer")
            footerView.toggleLoading(isEnabled: self.isPaginating)
            return footerView
        }
    }
}


//MARK: - UICollectionViewDelegate
extension PaginationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == paginationBreeds.count - 1 {
            print("reached las \(indexPath.item)")
            isPaginating = true
            Task {
                do {
                    let newPage = try await PaginationController.shared.fetchBreeds(matching: query)
                    
                    self.paginationBreeds += newPage
                    await dataSource.apply(snapshot, animatingDifferences:  true)
                    page += 1
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.2,
                       animations: {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.transform = CGAffineTransform.identity
            
            guard let urlString = self.paginationBreeds[indexPath.item].breeds[0].wikipediaURL,
                  let url = URL(string: urlString) else {
                return
            }

            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true)
        }
   }
}
