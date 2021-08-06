//
//  DataModel.swift
//  JPMorgan
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 06/08/21.
//

import Foundation
import UIKit

struct DataModel:Hashable {
    
    static func == (lhs: DataModel, rhs: DataModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var planetName   : String
}
