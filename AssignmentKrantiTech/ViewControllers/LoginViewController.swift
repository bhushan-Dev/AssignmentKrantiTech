//
//  LoginViewController.swift
//  AssignmentKrantiTech
//
//  Created by Bhushan Udawant on 10/04/20.
//  Copyright © 2020 Bhushan Udawant. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: IBActions

    @IBAction func login(_ sender: UIButton) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            return
        }

        guard let homePageViewController = storyboard?.instantiateViewController(identifier: "HomePageViewController") as? HomePageViewController else {
            return
        }

        homePageViewController.modalPresentationStyle = .fullScreen

        self.present(homePageViewController, animated: true)
    }
}

