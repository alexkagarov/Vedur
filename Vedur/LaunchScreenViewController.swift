//
//  LaunchScreenViewController.swift
//  Vedur
//
//  Created by Alex Kagarov on 7/1/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0) {
            self.progressView.setProgress(1.0, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.proceedToProgram()
        }
        
    }
    
    func proceedToProgram() {
        performSegue(withIdentifier: "endBoringLaunch", sender: nil)
    }

}
