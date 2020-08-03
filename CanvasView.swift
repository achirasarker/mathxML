//
//  CanvasView.swift
//  mathxml 
//
//  Created by Achira Sarker
//  2020-07-25
//

import UIKit

class CanvasView: UIView {
    var lineColour: UIColor!
    var lineWidth: CGFloat!
    //path is the lines we're drawing on canvas (UIView)
    var path: UIBezierPath!
    //touchpoint is where we touch our point
    var touchPoint:CGPoint!
    var startPoint:CGPoint!
    
    override func layoutSubviews() {
        //cannot draw over edges
        self.clipsToBounds = true
        //restrict multiple touches from being enabled
        self.isMultipleTouchEnabled = false
        //initialize line colour
        lineColour = UIColor.white
        lineWidth = 10
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //create touch object using touches as parameter
        let touch = touches.first
        startPoint = touch?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        touchPoint = touch?.location(in: self)
        
        path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: touchPoint)
        //update startPoint to current touchPoint
        startPoint = touchPoint
        //call our draw func
        drawShapeLayer()
    }
    
    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColour.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    
    func clearCanvas() {
        path.removeAllPoints()
        self.layer.sublayers = nil
        //set setNeedsDisplay to redraw our entire canvas
        self.setNeedsDisplay()
    }
    
}

//take a screenshot by passing UIView to Image (we get image from UIView)
extension UIImage {
    convenience init (view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size) 
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
