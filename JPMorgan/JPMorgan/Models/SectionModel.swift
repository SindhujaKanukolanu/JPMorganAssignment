//
//  SectionModel.swift
//  JPMorgan
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 06/08/21.
//

import Foundation

struct SectionModel: Hashable, Equatable {

    var title: String
    var rows: [DataModel]
    
    let uniqueId = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueId)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uniqueId == rhs.uniqueId
    }

}
