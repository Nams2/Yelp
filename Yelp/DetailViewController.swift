//
//  DetailViewController.swift
//  Yelp
//
//  Created by Namrata Mehta on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    //var businesses: [Business]!
    var business: Business!
    //var userLocation: UserLocation = UserLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = business.name
        
        self.addressLabel.text = business.address
        
        self.categoryLabel.text = business.categories
        
        if (self.business.imageURL != nil) {
            self.posterImageView.setImageWith(self.business.imageURL!)
        }
        self.posterImageView.layer.cornerRadius = 9.0
        self.posterImageView.layer.masksToBounds = true
        
        self.mapView.delegate = self
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: (self.business.coordinate?.latitude)!, longitude: (self.business.coordinate?.longitude)!)
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpanMake(0.01, 0.01)), animated: false)
        self.mapView.layer.cornerRadius = 9.0
        self.mapView.layer.masksToBounds = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view!.canShowCallout = false
        }
        return view
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
