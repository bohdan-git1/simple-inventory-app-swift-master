//
//  Global.swift
//  Collectkins
//
//  Created by Consigliere on 6/22/16.
//  Copyright © 2016 Mobile Consigliere. All rights reserved.
//

import Foundation

struct Constants {
    struct SearchCriteriaOptions {
        
//        static let series = ["Season 1", "Season 2", "Season 3", "Season 4", "Season 5"]
        static let teams = ["Fruit & Veg", "Pantry", "Bakery", "Sweet Treats", "Dairy", "Party Food", "Health & Beauty", "Frozen", "Cleaning & Laundry", "Homewares", "Shoes", "Baby", "Hats", "Stationary", "International Food", "Accessories", "Petshop", "Garden", "Party Time", "Petkins", "Sport", "Music", "Charms", "Tech"]
        static let rarities = ["Common", "Rare", "Ultra Rare", "Special Edition", "Limited Edition"]
        static let statuses = ["Active", "Wishlist"]
        
    }
}

struct Global {
    struct Data {
        
        static var series: [SeriesMO]?
        static var teams: [TeamMO]?
        static var rarities: [RarityMO]?
        static var statuses: [StatusMO]?
        
    }
}