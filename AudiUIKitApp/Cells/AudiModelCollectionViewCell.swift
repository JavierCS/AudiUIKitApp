//
//  AudiModelCollectionViewCell.swift
//  RESTExample
//
//  Created by jcruzsa on 02/11/22.
//

import UIKit
//Importamos kingfisher para manejar imágenes en cache
import Kingfisher

//Definimos el protocolo para pintar la imagen de los modelos de audi en esta celda
protocol AudiModelCollectionViewCellProtocol {
    func getImageUrl() -> String?
}

//Se crea este objeto para pasar la url al image view
class DownloadResource: Resource {
    var cacheKey: String
    var downloadURL: URL
    
    init(cacheKey: String, downloadURL: URL) {
        self.cacheKey = cacheKey
        self.downloadURL = downloadURL
    }
}

class AudiModelCollectionViewCell: UICollectionViewCell {
    //MARK: - UIElements
    @IBOutlet weak var modelImage: UIImageView!
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func drawData(_ model: AudiModelCollectionViewCellProtocol) {
        //Se hace el unwrap del string y posteriormente se inicializa una url para construir un objeto DownloadResource y pasarlo al imageview para ser descargado y almacenado en caché con king fisher
        guard let urlString = model.getImageUrl(),
              let url = URL(string: urlString) else { return }
        let downloadResource = DownloadResource(cacheKey: urlString, downloadURL: url)
        modelImage.kf.setImage(with: Source.network(downloadResource))
    }
}
