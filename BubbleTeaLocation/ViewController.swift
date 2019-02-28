import Alamofire
import GoogleMaps
import UIKit


class ViewController: UIViewController {

    
    
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        mapView.delegate = self
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: 13.7461123, longitude: 100.531919))
        
        marker.map = mapView
    }
    @IBAction func findAction(_ sender: Any) {
        Alamofire
            .request("https://api.foursquare.com/v2/venues/search?client_id=54DF2IFVBB1B5QRA34E3WQO51TAACS3QP0D3UE5A00E4QSM4&client_secret=3TRUIHNVY3201AUQLMXZMBNJU0HX33MEUNR02VNTG4BJIVA1&v=20180323&limit=10&ll=\(locationManager.location?.coordinate.latitude ?? 0.0),\(locationManager.location?.coordinate.longitude ?? 0.0)&query=bubbletea")
            .responseJSON(completionHandler: { res in
//                guard let json = res.result.value as? [String:Any] else {
//                    return
//                }
//
//                guard let response = json["response"] as? [String:Any] else {
//                    return
//                }
//
//                guard let venues = response["venues"] as? [[String:Any]] else {
//                    return
//                }
//
//                print(venues)
                
                  guard let data = res.data else {
                      return
                  }

                  let responseData = try? JSONDecoder().decode(JsonResponse.self, from: data)

                  print(responseData?.response.venues)
                
                responseData?.response.venues.forEach { venue in
                    let coordinate = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
                    let marker = GMSMarker(position: coordinate)
                    marker.map = self.mapView
                    marker.title = venue.name
                }
//                venues.forEach{ venue in
//                    let place = Place(venue: venue)
//                    print(place.name)
//                    let marker = GMSMarker(position: place.location)
//                    marker.map = self.mapView
//                    marker.title = place.name
//                }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? VenueDetailViewController
            let name = sender as? String
            vc?.name = name
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager (_ manager: CLLocationManager,
                          didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager (_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        mapView.camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.title)
        
        performSegue(withIdentifier: "showDetail", sender: marker.title)
        return true
    }
}
