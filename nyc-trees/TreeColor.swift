//
//  TreeColor.swift
//  nyc-trees
//
//  Created by Suri Wigder on 3/24/19.
//  Copyright © 2019 Suri Wigder. All rights reserved.
//

import Foundation
import UIKit

let treeColors: [String: UIColor] = [
    "Platanus x acerifolia": .init(red: 6, green: 128, blue: 5),
    "Koelreuteria paniculata": .init(red: 146, green: 135, blue: 42),
    "Gleditsia triacanthos var. inermis": .init(red: 125, green: 134, blue: 164),
    "Quercus imbricaria": .init(red: 56, green: 103, blue: 3),
    "Tilia americana": .init(red: 162, green: 84, blue: 37),
]

let defaultTreeColor: UIColor = .green

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
}

