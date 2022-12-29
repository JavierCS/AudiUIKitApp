//
//  ViewController.swift
//  AudiUIKitApp
//
//  Created by jcruzsa on 28/11/22.
//

class AudiCarModel: Decodable {
    var modelName: String?
    var modelYear: Int?
    var imageUrl: String?
    var initialPrice: Double?
    var versions: [AudiCarVersion]?
}

extension AudiCarModel: AudiModelCollectionViewCellProtocol {
    func getImageUrl() -> String? {
        return imageUrl
    }
}

class AudiCarVersion: Decodable {
    var versionName: String?
    var initialPrice: Double?
    var imageUrl: String?
    var stock: Int?
}

import UIKit

class ViewController: UIViewController {
    //MARK: - UIElements
    @IBOutlet weak var modelsCollection: UICollectionView!
    
    //MARK: - Logic Vars
    var url: String = "https://www.dropbox.com/s/25nl23900z1xmf6/CarsList.json?dl=1"
    var models: [AudiCarModel] = []
    
    //MARK: - LifeCycle Management
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
        fetchCars()
    }
    
    private func initialConfiguration() {
        title = "Choose your new Audi"
        modelsCollection.register(UINib(nibName: "AudiModelCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "id")
        modelsCollection.dataSource = self
        modelsCollection.delegate = self
    }
    
    //MARK: - Data Management
    private func fetchCars() {
        guard let url = URL(string: self.url) else {
            showError(message: "Can't create url for request")
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, urlResponse, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showError(message: error.localizedDescription)
                }
                return
            }
            guard let data = data,
                  let response = try? JSONDecoder().decode([AudiCarModel].self, from: data)
            else {
                DispatchQueue.main.async {
                    self.showError(message: "Can't build response model from service data")
                }
                return
            }
            DispatchQueue.main.async {
                self.showModels(response)
            }
        }
        task.resume()
    }
    
    private func showModels(_ models: [AudiCarModel]) {
        self.models = models
        modelsCollection.reloadData()
    }
    
    //MARK: - Error Management
    private func showError(message: String) {
        let alertController = UIAlertController(title: "Audi", message: message, preferredStyle: .alert)
        present(alertController, animated: true)
    }

}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as? AudiModelCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.drawData(models[indexPath.row])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout Management
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.width / 2)
    }
}
