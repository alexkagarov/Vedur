//
//  ContainerViewController.swift
//  Vedur
//
//  Created by Alex Kagarov on 6/22/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ContainerViewController: UIViewController {
    //  OUTLETS & VARS
    @IBOutlet weak var mainContainerViewController: UIView!
    private var sideMenuIsVisible = false
    
    // CONSTRAINTS
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locMan = LocationManager.shared
        
        locMan.requestAlwaysAuthorization()
        locMan.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locMan.delegate = self
            locMan.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locMan.startUpdatingLocation()
        }
        
        NotificationCenter.default.addObserver(self, selector:       #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if self.view.frame.contains(location) && sideMenuIsVisible {
            toggleSideMenu()
        }
    }
    
    @objc func toggleSideMenu() {
        if sideMenuIsVisible {
            sideMenuIsVisible.toggle()
            mainContainerViewController.isUserInteractionEnabled.toggle()
            sideMenuConstraint.constant = -250
        } else {
            sideMenuIsVisible.toggle()
            mainContainerViewController.isUserInteractionEnabled.toggle()
            sideMenuConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension ContainerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("Current location = \(locValue.latitude) \(locValue.longitude)")
    }
}
