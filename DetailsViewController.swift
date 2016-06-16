//
//  DetailsViewController.swift
//  Flix
//
//  Created by Jeanne Luning Prak on 6/15/16.
//  Copyright © 2016 Jeanne Luning Prak. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var innerBox: UIView!
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var summary: UITextView!
    @IBOutlet weak var buyTickets: UIButton!
    
    var sentIndex = 0
    var movies : [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        innerBox.layer.borderColor = UIColor.whiteColor().CGColor
        buyTickets.layer.borderColor = UIColor.whiteColor().CGColor
        
        let movie = movies![sentIndex]
        let setTitle = movie["title"] as! String
        movieTitle.text = setTitle
        let setSummary = movie["overview"] as! String
        summary.text = setSummary
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        let posterPath = movie["poster_path"] as! String
        let url = NSURL(string: baseUrl + posterPath)
        poster.setImageWithURL(url!)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goMovieTickets(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.movietickets.com/movies#.V2IVmJMrJsM")!)
        
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
        summary.flashScrollIndicators()
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
