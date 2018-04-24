//
//  PieChartView.swift
//  SwiftPieChart
//
//  Created by Nicolás Miari on 2018/04/20.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

///

public protocol PieChartViewDelegate: AnyObject {
    func pieChartView(_ view: PieChartView, colorForSliceAt index: Int) -> UIColor
}

// MARK: -

/// - todo: Make `@IBDesignable` (even if with dummy chart content).
///
open class PieChartView: UIView {

    // MARK: - Public Interface

    ///
    public weak var delegate: PieChartViewDelegate?

    ///
    public var values: [Double] = [1.0] {
        didSet {
            guard values.count > 0 else { return } // Needed?
            let total = values.reduce(0, +)

            self.normalizedValues = values.map {
                return CGFloat($0/total)
            }
            updateSlices()
        }
    }

    // MARK: - UIView

    override public init(frame: CGRect) {
        self.containerLayer = CALayer()
        super.init(frame: frame)
        self.layer.addSublayer(containerLayer)
        containerLayer.contentsScale = UIScreen.main.scale
    }

    required public init?(coder aDecoder: NSCoder) {
        self.containerLayer = CALayer()
        super.init(coder: aDecoder)
        self.layer.addSublayer(containerLayer)
        containerLayer.contentsScale = UIScreen.main.scale
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }

    // MARK: - Internals

    private var normalizedValues: [CGFloat] = [1.0]

    private var containerLayer: CALayer

    private func updateSlices() {
        containerLayer.frame = self.bounds

        let sublayerCount = containerLayer.sublayers?.count ?? 0
        print("Sublayer count: \(sublayerCount)")

        let growFromZero = sublayerCount != normalizedValues.count

        if normalizedValues.count > sublayerCount {
            // Add
            let difference = normalizedValues.count - sublayerCount
            for _ in 0 ..< difference {
                let newSlice = PieSliceLayer()
                //newSlice.contentsScale = self.contentScaleFactor
                newSlice.frame = self.bounds
                containerLayer.addSublayer(newSlice)
            }
        } else if normalizedValues.count < sublayerCount {
            // Remove
            let difference = sublayerCount - normalizedValues.count
            for _ in 0 ..< difference {
                containerLayer.sublayers?[0].removeFromSuperlayer()
            }
        }

        var lastAngle: CGFloat = 0.0

        for (index, value) in normalizedValues.enumerated() {
            guard let slice = containerLayer.sublayers?[index] as? PieSliceLayer else {
                continue
            }

            let deltaAngle = value * CGFloat.tau // 2π

            //if let color = delegate?.pieChartView(self, colorForSliceAt: index) {
            //    slice.fillColor = color
            //} else {
                let hue = (lastAngle + (0.5 * deltaAngle) ) / CGFloat.tau
                slice.fillColor = UIColor(hue: hue, saturation: 0.7, brightness: 0.85, alpha: 1.0)
            //}
            slice.growFromZeroSize = growFromZero
            slice.startAngle = lastAngle
            slice.endAngle = lastAngle + deltaAngle

            lastAngle += deltaAngle
        }
    }
}

extension CGFloat {

    /// Angle of one full turn, τ (=2π).
    //
    static var tau: CGFloat {
        return (2 * CGFloat.pi)
    }
}
