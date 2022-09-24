//
//  ItemsViewModel.swift
//  SimpleMapApp
//
//  Created by Ege Girsen on 23.09.2022.
//

import Foundation

struct ItemsViewModel{
    
    let position: [Double]
    let distance: Int?
    let title: String?
    let category: String?
    let id: String?
    
    
    init(items: Items){
        self.position = items.position
        self.distance = items.distance
        self.title = items.title
        self.category = items.category.title
        self.id = items.id
    }
}
