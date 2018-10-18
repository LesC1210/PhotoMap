//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "\(annotation.coordinate.latitude)"
        mapView.addAnnotation(annotation)
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self as? MKMapViewDelegate
        
      
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                              MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func didTapCameraButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available.")
            vc.sourceType = .camera
        } else {
            print("Camera not available so we will use photo library instead.")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = UIImage(named: "camera")
        
        return annotationView
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage

        dismiss(animated: true, completion: showLocationViewController)
    }
    
    func showLocationViewController() -> Void {
        self.performSegue(withIdentifier: "tagSegue", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LocationsViewController {
            vc.delegate = self
        }
    }
    

}
