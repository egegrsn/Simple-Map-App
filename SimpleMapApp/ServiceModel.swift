//
//  ServiceModel.swift
//  SimpleMapApp
//
//  Created by Ege Girsen on 21.09.2022.
//

import Foundation

struct ServiceModel: Decodable{
    var results : Results
}

struct Results: Decodable{
    var items : [Items]
}

struct Items: Decodable{
    var position: [Double]
    var distance: Int?
    var title: String?
    var category: Categories
    var id: String?
}

struct Categories: Decodable{
    var title: String?
}

