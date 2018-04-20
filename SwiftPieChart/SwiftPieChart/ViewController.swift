//
//  ViewController.swift
//  SwiftPieChart
//
//  Created by Nicolás Miari on 2018/04/20.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!

    private var index = 1

    private var dataSets = [[Double]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        dataSets.append([
            1, 2, 3, 1])
        dataSets.append([
            1, 1, 2])
        dataSets.append([
            1, 1, 1])
        dataSets.append([
            1, 1, 1, 2, 1, 6])
        dataSets.append([
            1, 1, 6, 9, 110])
        dataSets.append([
            1, 1, 1, 1, 1, 1, 1])

        pieChartView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func animateChart(_ sender: UIButton) {

        pieChartView.values = dataSets[index]

        index = (index + 1) % dataSets.count
    }
}

extension ViewController: PieChartViewDelegate {

    func pieChartView(_ view: PieChartView, colorForSliceAt index: Int) -> UIColor {
        //let count = dataSets[index].count

        switch index % 3 {
        case 0:
            return UIColor.red
        case 1:
            return UIColor.green
        default:
            return UIColor.blue
        }
    }
}
