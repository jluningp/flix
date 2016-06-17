//
//  DetailsViewController.swift
//  Flix
//
//  Created by Jeanne Luning Prak on 6/15/16.
//  Copyright © 2016 Jeanne Luning Prak. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var summary: UITextView!
    @IBOutlet weak var innerBox: UIView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var buyTickets: UIButton!
    
    var sentIndex = 0
    var movies : [NSDictionary]?
    var movieDetails : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        innerBox.layer.borderColor = UIColor.whiteColor().CGColor
        buyTickets.layer.borderColor = UIColor.whiteColor().CGColor
        
        let movie = movies![sentIndex]
        let setSummary = movie["overview"] as! String
        summary.text = setSummary
        let setTitle = movie["title"] as! String
        movieTitle.text = setTitle
        let setRating = String(format: "%.1f", movie["vote_average"] as! Double)
        rating.text = "Rating: \(setRating)/10"
        let setReleaseDate = movie["release_date"] as! String
        releaseDate.text = "Release Date: \(setReleaseDate)"
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = NSURL(string: baseUrl + posterPath)
        poster.setImageWithURL(posterUrl!)
        
        let apiKey = "ef2dab19dabe5f6bca876496b7d76ab7"
        let movieID = movie["id"] as! Int
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&append_to_response=credits")
        
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
                    self.movieDetails = responseDictionary as NSDictionary
                    self.tableView.reloadData()
                }
            }
        })
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goFandango(sender: AnyObject) {
        let searchTitle = movies![sentIndex]["title"] as! String
        let toSearch = searchTitle.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let url = "http://www.fandango.com/search?q=" + toSearch + "&mode=general"
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //summary.flashScrollIndicators()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movieDetails = movieDetails {
            print(movieDetails["credits"]!["cast"]!!.count)
            return movieDetails["credits"]!["cast"]!!.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActorCell", forIndexPath: indexPath) as! ActorCell
        if let movieDetails = movieDetails {
            let actors = movieDetails["credits"]!["cast"] as! [NSDictionary]
            if(indexPath.row < actors.count) {
                let actor = actors[indexPath.row]
                let name = actor["name"] as! String
                cell.actor.text = name
                let roll = actor["character"] as! String
                cell.roll.text = roll
                let baseUrl = "https://image.tmdb.org/t/p/w342"
                let profile = actor["profile_path"]
                if let profile = profile as? String {
                    let posterPath = profile
                    let url = NSURL(string: baseUrl + posterPath)
                    cell.poster.setImageWithURL(url!)
                }
            }
            
        }
        return cell
    }

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
