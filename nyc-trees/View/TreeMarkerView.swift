//
//  TreeMarkerView.swift
//  nyc-trees
//
//  Created by Suri Wigder on 3/24/19.
//  Copyright © 2019 Suri Wigder. All rights reserved.
//

import Foundation
import MapKit

class TreeMarkerView: MKAnnotationView {
    
    var color: CGColor = UIColor.clear.cgColor
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let tree = newValue as? Tree else { return }
            canShowCallout = false
            calloutOffset = CGPoint(x: -5, y: 5)
            color = treeColors[tree.latinName]?.cgColor ?? defaultTreeColor.cgColor
            let diameter = 5 + tree.diameter / 2
            frame = CGRect(x:0, y:0, width:diameter, height:diameter)
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        layer.sublayers?.removeAll()
        
        let halfLineWidth:CGFloat = 0.75
        
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: halfLineWidth, dy: halfLineWidth))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = color.copy(alpha: 0.8)
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = halfLineWidth * 2
        layer.addSublayer(shapeLayer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let shapeLayer = layer.sublayers?[0] as! CAShapeLayer
        if selected {
            let selectedColor = color.copy(alpha: 0.5)
            shapeLayer.strokeColor = selectedColor
            shapeLayer.fillColor = selectedColor
        } else {
            shapeLayer.strokeColor = color
            shapeLayer.fillColor = color.copy(alpha: 0.8)
        }
    }
}

class TreeMarkerSelectedView: MKPinAnnotationView {

}
