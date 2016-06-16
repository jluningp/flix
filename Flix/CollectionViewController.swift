//
//  CollectionViewController.swift
//  Flix
//
//  Created by Jeanne Luning Prak on 6/16/16.
//  Copyright © 2016 Jeanne Luning Prak. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var collectionView: UICollectionView!
    let totalColors: Int = 100
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func colorForIndexPath(indexPath: NSIndexPath) -> UIColor {
        if indexPath.row >= totalColors {
            return UIColor.blackColor()	// return black if we get an unexpected row index
        }
        
        let hueValue: CGFloat = CGFloat(indexPath.row) / CGFloat(totalColors)
        return UIColor(hue: hueValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalColors
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! MovieCollectionCell
        let cellColor = colorForIndexPath(indexPath)
        cell.backgroundColor = cellColor
        
        if CGColorGetNumberOfComponents(cellColor.CGColor) == 4 {
            let redComponent = CGColorGetComponents(cellColor.CGColor)[0] * 255
            let greenComponent = CGColorGetComponents(cellColor.CGColor)[1] * 255
            let blueComponent = CGColorGetComponents(cellColor.CGColor)[2] * 255
            cell.color.text = String(format: "%.0f, %.0f, %.0f", redComponent, greenComponent, blueComponent)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow = 3
        let oddEven = indexPath.row / numberOfCellsPerRow % 2
        let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
        if (oddEven == 0) {
            return CGSizeMake(dimensions, dimensions)
        } else {
            return CGSizeMake(dimensions, dimensions / 2)
        }
    }
}
