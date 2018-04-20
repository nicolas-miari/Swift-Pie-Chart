//
//  PieSliceLayer.swift
//  SwiftPieChart
//
//  Created by Nicolás Miari on 2018/04/20.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/// Custom CoreAnimation layer subclass tha renders a single pie chart slice
/// whose ectent can be animated.
///
/// Based on this tutorial:
/// https://blog.pixelingene.com/2012/02/animating-pie-slices-using-a-custom-calayer/
/// (Sample project: https://github.com/pavanpodila/PieChart)
///
class PieSliceLayer: CALayer {

    @NSManaged public var startAngle: CGFloat
    @NSManaged public var endAngle: CGFloat

    public var fillColor: UIColor = .red
    public var strokeWidth: CGFloat = 0.0
    public var strokeColor: UIColor = .darkGray

    // MARK: - CALayer

    override init() {
        super.init()
        setNeedsDisplay()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        if let other = layer as? PieSliceLayer {
            self.startAngle = other.startAngle
            self.endAngle = other.endAngle
            self.fillColor = other.fillColor
            self.strokeWidth = other.strokeWidth
            self.strokeColor = other.strokeColor
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func action(forKey event: String) -> CAAction? {
        switch event {
        case "startAngle", "endAngle":
            return makeAnimation(forKey: event)
        default:
            return super.action(forKey: event)
        }
    }

    override class func needsDisplay(forKey event: String) -> Bool {
        switch event {
        case "startAngle", "endAngle":
            return true
        default:
            return super.needsDisplay(forKey: event)
        }
    }

    override func draw(in ctx: CGContext) {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = min(center.x, center.y)

        ctx.beginPath()
        ctx.move(to: center)

        let point1 = CGPoint(x: center.x + radius*cos(startAngle), y: center.y + radius*sin(startAngle))
        ctx.addLine(to: point1)

        let clockwise = (startAngle > endAngle)
        ctx.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)

        ctx.closePath()

        ctx.setFillColor(fillColor.cgColor)
        ctx.setStrokeColor(strokeColor.cgColor)
        ctx.setLineWidth(strokeWidth)

        ctx.drawPath(using: .fillStroke)
    }

    // MARK: - Internal

    fileprivate func makeAnimation(forKey event: String) -> CAAnimation? {
        let animation = CABasicAnimation(keyPath: event)
        animation.fromValue = self.presentation()?.value(forKey: event)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = 0.5

        return animation
    }
}
