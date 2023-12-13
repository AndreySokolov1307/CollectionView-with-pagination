//
//  CatViewController.swift
//  CollectionView CatInfo Cathing with pagination
//
//  Created by Андрей Соколов on 28.10.2023.
//

import UIKit
import SafariServices

class BreedViewController: UIViewController {
    
    private let breedView = BreedView()
    
    private var allBreeds = [Breed]()
    
    private let breedController  = BreedController()
    
    private var dataSource: UICollectionViewDiffableDataSource<String, Breed>! = nil
    private var snapshot: NSDiffableDataSourceSnapshot<String, Breed> {
        
        var snapshot = NSDiffableDataSourceSnapshot<String, Breed>()
        snapshot.appendSections(["Results"])
        snapshot.appendItems(allBreeds)
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
        fetchAllBreeds()
        congifureCollectionViewDataSource()
    }
    
    private func fetchAllBreeds() {
        Task {
            do {
                
                self.allBreeds = try await self.breedController.fetchAllBreeds()
            } catch {
                print(error)
            }
            await dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func congifureCollectionViewDataSource()  {
        dataSource = UICollectionViewDiffableDataSource<String, Breed>(collectionView: breedView.collectionView, cellProvider: {(collectionView, indexPath, breed) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedCell.reuseIdentifier, for: indexPath) as! BreedCell
            
            Task {
                    await cell.configure(for: breed, breedController: self.breedController)
                
            }
            
            return cell
        })
        
        //MARK: - SupplementaryViewProvider
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.reuseIdentifier, for: indexPath) as! FooterView
        
            return footerView
        }
    }
}


//MARK: - UICollectionViewDelegate
extension BreedViewController : UICollectionViewDelegate {
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         guard let urlString = allBreeds[indexPath.row].wikipediaURL,
               let url = URL(string: urlString) else {
             return
         }

         let vc = SFSafariViewController(url: url)
         present(vc, animated: true)
    }
}



