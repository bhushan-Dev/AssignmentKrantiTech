//
//  HomePageViewController.swift
//  AssignmentKrantiTech
//
//  Created by Bhushan Udawant on 10/04/20.
//  Copyright © 2020 Bhushan Udawant. All rights reserved.
//

import UIKit
import Alamofire

enum APICallType {
    case fetch
    case create
}

class HomePageViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak var getEmployeesButton: UIButton!
    @IBOutlet weak var createEmployeeButton: UIButton!
    @IBOutlet weak var employeeDetailsContainerView: UIView!
    @IBOutlet weak var employeeTableView: UITableView!
    @IBOutlet weak var createContainerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    // MARK: Properties

    var employeeList: [EmployeeModel]?

    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    // MARK: IBActions

    @IBAction func createEmployee(_ sender: UIButton) {
        createContainerView.isHidden = false
        employeeTableView.isHidden = true
    }

    @IBAction func beginCreatingEmployee(_ sender: UIButton) {
        let service = Service()
        service.createData(payload: getPayload()) { [weak self] (success, error) in

            if Result.success == success {
                guard let strongSelf = self else {
                    return
                }

                DispatchQueue.main.async {
                    // Show Alert
                    strongSelf.showAlert(type: .create)
                }
            }
        }
    }

    @IBAction func getEmployees(_ sender: UIButton) {
        createContainerView.isHidden = true
        employeeTableView.isHidden = false

        let service = Service()
        service.fetchData { [weak self] (success, error) in

            if Result.success == success {
                guard let strongSelf = self else {
                    return
                }

                DispatchQueue.main.async {
                    strongSelf.employeeList = service.employeeList
                    strongSelf.employeeTableView.reloadData()
                    // Show Alert
                    strongSelf.showAlert(type: .fetch)
                }
            }
        }
    }
}

// MARK: - Table View Delegate -

extension HomePageViewController: UITableViewDelegate {

}

// MARK: - Table View DataSource -

extension HomePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")

        if let employeeList = employeeList {
            let employee = employeeList[indexPath.row]

            cell?.textLabel?.text = employee.employeeName
            cell?.detailTextLabel?.text = "Salary: " + employee.employeeSalary
        }

        return cell!
    }
}

// MARK: - Private Mehotds -

extension HomePageViewController {
    private func setupView() {
        employeeTableView.dataSource = self
    }

    private func showAlert(type: APICallType) {

        var titleAlert = ""

        switch type {
        case .fetch:
            titleAlert = "Fetch Completed"
        case .create:
            titleAlert = "Creation Completed"
        }

        let alert = UIAlertController(title: titleAlert, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }

    private func getPayload() -> [String: String?] {
        let name = self.nameTextField.text
        let age = self.ageTextField.text
        let salary = self.salaryTextField.text

        let payload = ["name": name, "salary": salary, "age": age]

        return payload
    }
}
