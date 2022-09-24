//
//  Service.swift
//  SimpleMapApp
//
//  Created by Ege Girsen on 21.09.2022.
//

import Foundation
import Alamofire

class Service{
    static let shared = Service()
    
    func fetchPlaces(lat: String,lng: String, searchSize: String,text: String ,completion: @escaping ([Items]?, Error?) -> ()) {
        let urlEncodedText = text.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        
        AF
            .request(Globals.baseUrl+"?at="+lat+","+lng+"&q="+urlEncodedText!+"&apiKey="+Globals.apiKey+"&size="+searchSize)
            .responseDecodable(of: ServiceModel.self) { response in
                switch response.result {
                case .success(let value):
                    DispatchQueue.main.async {
                        completion(value.results.items, nil)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
