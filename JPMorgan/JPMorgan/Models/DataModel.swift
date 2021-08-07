//
//  DataModel.swift
//  JPMorgan
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 06/08/21.
//

import Foundation
import UIKit

struct DataModel:Hashable {
    
    let uuid = UUID()
    static func == (lhs: DataModel, rhs: DataModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    var planetName   : String
    var rotation_period: String
}
