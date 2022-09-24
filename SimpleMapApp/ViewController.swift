//
//  ViewController.swift
//  SimpleMapApp
//
//  Created by Ege Girsen on 21.09.2022.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation
import FloatingPanel
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, UISheetPresentationControllerDelegate, UIViewControllerTransitioningDelegate, FloatingPanelControllerDelegate{
    
    var lat = String()
    var lng = String()
    var searchText = String()
    var searchSize = "10"
    var itemsViewModels = [ItemsViewModel]()
    private var locationManager = CLLocationManager()
    var fpc = FloatingPanelController()
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap()
        setFloatingPanel()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.view.addGestureRecognizer(gesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Moving the view with keyboard for UI improvement.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
  
    // If the user clicks somewhere on the screen, keyboard is dismissing and floating panel is minimizes.
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        fpc.move(to: .tip, animated: true)
        view.endEditing(true)
    }
    
    // Floating panel functions (search bar)
    func setFloatingPanel(){
        fpc.delegate = self
        fpc.layout = MyFloatingPanelLayout()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
        vc.delegate = self
        
        fpc.panGestureRecognizer.isEnabled = false
        fpc.surfaceView.appearance.cornerRadius = 24.0
        fpc.surfaceView.appearance.borderWidth = 1.0 / traitCollection.displayScale
        fpc.surfaceView.appearance.borderColor = UIColor.black.withAlphaComponent(0.2)
        fpc.set(contentViewController: vc)
        fpc.addPanel(toParent: self)
    }
    
    // Search function which takes user coordinates, search text and search size. This function returns values from API and call addPinsToMap function.
    fileprivate func search(searchText: String){
        if locationEnabled(){
            Service.shared.fetchPlaces(lat: lat, lng: lng, searchSize: searchSize, text: searchText) { (results, err) in
                if let err = err {
                    print("Failed to fetch courses:", err)
                    return
                }
                if results?.count == 0 {
                    self.showAlert(message: "No results found. Please try again.", title: "Sorry")
                }else{
                    self.itemsViewModels = results?.map({return ItemsViewModel(items: $0)}) ?? []
                    self.addPinsToMap()
                }
            }
            saveSearchQueryToCoreData()
            getAllSearchesFromCoreData()
        }
    }
    
    // Set the map as view loads.
    func setMap(){
        // Ask for authorisation from the user.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        // Focus the map on the user's location.
        if let userCoordinates = mapView.userLocation.location?.coordinate{
            mapView.setCenter(userCoordinates, animated: true)
        }
    }
    
    // Gets user's location and sets its region and span of the map.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        mapView.mapType = MKMapType.standard
        
        // Get user's location coordinates and store it.
        lat = "\(locValue.latitude)"
        lng = "\(locValue.longitude)"
        
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // As the search API returns location values, function pins those places and shows them in the map.
    func addPinsToMap(){
        for item in itemsViewModels{
            let annotation = MKPointAnnotation()
            annotation.title = item.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: item.position[0], longitude: item.position[1])
            annotation.subtitle = item.category
            
            mapView.addAnnotation(annotation)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    // Function to enable pins not to overlap each other, also diffirentiates them from user's own location pin.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "annotationView"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        
        // this enables pins to not overlap each other, so we can see all of them.
        view?.displayPriority = .required
        view?.annotation = annotation
        view?.canShowCallout = true
        
        // to exclude user pin from other pins
        if let userAnnotation = annotation as? MKUserLocation {
            userAnnotation.title = ""
            return nil
        }
        // adding button to pins
        let button = UIButton(type: .close) as UIButton // button with info sign in it
        view?.rightCalloutAccessoryView = button
        return view
    }
    
    // Close button action for pins.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let pin = view.annotation
        mapView.deselectAnnotation(pin, animated: true)
    }
    
    // Checks the location services and gives alert according to it.
    func locationEnabled() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                self.showAlert(message: "To search a place, you need to enable location services.", title: "Sorry")
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                break
            }
        }
        return false
    }
    
    // Keyboard notifications to shift view.
    @objc func keyboardWillShow(notification: NSNotification) {
        fpc.move(to: .half, animated: true)
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        fpc.move(to: .tip, animated: true)
    }
    
    // CoreData function to save the search query which consist of date, coordinates and the search text.
    func saveSearchQueryToCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Search", in: context)
        let newSearch = Search(entity: entity!, insertInto: context)
        newSearch.createdAt = Date()
        newSearch.longitude = lng
        newSearch.latitude = lat
        newSearch.searchText = searchText
        
        do {
            try context.save()
        } catch {
            
        }
    }

    // For testing purposes.
    func getAllSearchesFromCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        do {
            let items = try context.fetch(Search.fetchRequest())
            debugPrint(items)
        } catch {
            
        }
    }
    
}

extension ViewController: searchProtocol{
    func sendSearchInput(searchStr: String){
        searchText = searchStr
        // Filters user's location annotation and removes other annotations.
        let annotations = mapView.annotations.filter({ !($0 is MKUserLocation) })
        mapView.removeAnnotations(annotations)
        // call search function
        search(searchText: searchText)
    }
}

// Floating Panel class. It's to customize the panel.
class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 44.0, edge: .bottom, referenceGuide: .safeArea),]
    }
    
    // For background shadow on map which only applies while searching.
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
        case .half: return 0.3
        default: return 0.0
        }
    }
}
