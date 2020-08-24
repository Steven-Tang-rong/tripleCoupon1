//
//  ViewController.swift
//  tripleCoupon
//
//  Created by TANG,QI-RONG on 2020/8/16.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
 
    var latitude = 0.0
    var longitude = 0.0
    
    var postData = [PostData]()
    
    let postAPI = "https://3000.gov.tw/hpgapi-openmap/api/getPostData"
    var getLocation = false
    
    @IBOutlet weak var postMapView: MKMapView!
    

 //MARK: - viewDidLoad
 

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
                
        if getLocation == false {
        //顯示區域的大小
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                
            //顯示地區座標
            mapView.setRegion(region, animated: true)
            getLocation = true
        }
        print("didUpdate")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                  
        postMapView.delegate = self
        locationManager.delegate = self
        
        func somelocationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
             print("error:: \(error.localizedDescription)")
        }

        func somelocationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                locationManager.requestLocation()
            }
        }

        func somelocationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

            manager.delegate = nil

            if locations.first != nil {
                print("location:: (location)")
            }
        }
        
        locationManager.requestWhenInUseAuthorization()
        // 精準度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
        locationManager.startUpdatingLocation()
        
        
        
        postMapView.showsUserLocation = true
        postMapView.userTrackingMode = .follow
        
//MARK: - Post API
        if let url = URL(string: postAPI) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                let decoder = JSONDecoder()
                
                if let data = data, let postResults = try? decoder.decode([PostData].self, from: data) {
                    
                    DispatchQueue.main.async {
                        self.postData = postResults
                        
                        
                        for post in self.postData{
                           
                            self.latitude = Double(post.latitude)!
                            self.longitude = Double(post.longitude)!
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
                            annotation.title = "本日剩餘張數\(post.total)張"
                            annotation.subtitle = post.storeNm;                       //self.postMapView.setCenter(annotation.coordinate, animated: true)
                          
                            
                            self.postMapView.addAnnotation(annotation)
                        }
                    }
                    
                }
                
            }.resume()
        }
        
       
    }
    
    //MARK: - 自訂標記

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         
         
         let identifier = "MyMarker"
                if annotation.isKind(of: MKUserLocation.self){
                    
                    return nil
                }
         
         var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                }
                
                annotationView?.glyphText = "🎁"
                annotationView?.markerTintColor = #colorLiteral(red: 1, green: 0.6856461903, blue: 0.684549072, alpha: 1)
                
                return annotationView
     }
}


