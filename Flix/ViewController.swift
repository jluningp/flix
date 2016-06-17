//
//  ViewController.swift
//  Flix
//
//  Created by Jeanne Luning Prak on 6/15/16.
//  Copyright © 2016 Jeanne Luning Prak. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var switchView: UISegmentedControl!
    @IBOutlet weak var error: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var movies : [NSDictionary]?
    var filteredMovies : [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        //tell table view that I am datasource
        tableView.dataSource = self
        searchBar.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
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
                        print("response: \(responseDictionary)")
                        self.movies = responseDictionary["results"] as! [NSDictionary]
                        self.filteredMovies = self.movies
                        self.tableView.reloadData()
                        
                    }
                }
            })
            task.resume()
            error.hidden = true
        } else {
            error.hidden = false
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    //Calls this function when the tap is recognized.
func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let row = indexPath.row
        let movie = filteredMovies![row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        let posterPath = movie["poster_path"] as! String
        let url = NSURL(string: baseUrl + posterPath)
        
        //Generic cell has built in image view and built in label
        cell.title.text = title
        cell.overview.text = overview
        cell.poster.setImageWithURL(url!)
        cell.info.tag = row
        return cell
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
                        print("response: \(responseDictionary)")
                        self.movies = responseDictionary["results"] as! [NSDictionary]
                        self.filteredMovies = self.movies
                        self.tableView.reloadData()
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
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let movies = movies {
        filteredMovies = searchText.isEmpty ? movies : movies.filter({(data: NSDictionary) -> Bool in
            return (data["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        tableView.reloadData()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "details" {
            let destination = segue.destinationViewController as! DetailsViewController
            destination.sentIndex = sender.tag
            print(sender.tag)
            destination.movies = self.filteredMovies
        }
    }
    
}

