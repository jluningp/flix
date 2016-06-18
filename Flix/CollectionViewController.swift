//
//  CollectionViewController.swift
//  Flix
//
//  Created by Jeanne Luning Prak on 6/16/16.
//  Copyright © 2016 Jeanne Luning Prak. All rights reserved.
//

import UIKit
import MBProgressHUD

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var error: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    var movies : [NSDictionary]?
    var filteredMovies : [NSDictionary]?
    let totalColors: Int = 100
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        dismissKeyboard()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        if (Reachability.isConnectedToNetwork() == true) {
            let apiKey = "ef2dab19dabe5f6bca876496b7d76ab7"
            let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
            let request = NSURLRequest(
                URL: url!,
                cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate: nil,
                delegateQueue: NSOperationQueue.mainQueue()
            )
            
            // Display HUD right before the request is made
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as! [NSDictionary]
                        self.filteredMovies = self.movies
                        self.collectionView.reloadData()
                        
                    }
                }
            })
            task.resume()
            error.hidden = true
        } else {
            error.hidden = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(textField: UISearchBar) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        if (Reachability.isConnectedToNetwork() == true) {
            let apiKey = "ef2dab19dabe5f6bca876496b7d76ab7"
            let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
            let request = NSURLRequest(
                URL: url!,
                cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate: nil,
                delegateQueue: NSOperationQueue.mainQueue()
            )
            
            let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as! [NSDictionary]
                        self.filteredMovies = self.movies
                        self.collectionView.reloadData()
                        refreshControl.endRefreshing()
                    }
                }
            })
            error.hidden = true
            task.resume()
        } else {
            refreshControl.endRefreshing()
            error.hidden = false
        }
    }
    
    func colorForIndexPath(indexPath: NSIndexPath) -> UIColor {
        if indexPath.row >= totalColors {
            return UIColor.blackColor()	// return black if we get an unexpected row index
        }
        
        let hueValue: CGFloat = CGFloat(indexPath.row) / CGFloat(totalColors)
        return UIColor(hue: hueValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! MovieCollectionCell
        let movie = filteredMovies![indexPath.row]
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        let posterPath = movie["poster_path"] as! String
        let url = NSURL(string: baseUrl + posterPath)
        
        //Generic cell has built in image view and built in label
        cell.poster.setImageWithURL(url!)
        cell.layer.borderColor = UIColor.darkGrayColor().CGColor
        cell.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow = 2
        let dimensions = CGFloat(((Int(totalwidth) - 10) / numberOfCellsPerRow))
        return CGSizeMake(dimensions, dimensions * 1.3)
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let movies = movies {
            filteredMovies = searchText.isEmpty ? movies : movies.filter({(data: NSDictionary) -> Bool in
                return (data["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
            collectionView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "details" {
            let destination = segue.destinationViewController as! DetailsViewController
            destination.sentIndex = sender.tag
            destination.movies = self.filteredMovies
        }
    }
}
