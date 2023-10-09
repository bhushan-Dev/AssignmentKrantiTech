//
//  Service.swift
//  AssignmentKrantiTech
//
//  Created by Bhushan Udawant on 10/04/20.
//  Copyright © 2020 Bhushan Udawant. All rights reserved.
//

import Foundation
import Alamofire

public enum Result {
    case success
    case error
}

class Service {

    var employeeList: [EmployeeModel]?

    init() {
        
    }

    public func fetchData(completionHandler: @escaping (Result?, Result?) -> Void) {
        guard let url = URL(string: Constants.baseURL + "employees") else {
            return
        }

        let request = URLRequest(url: url)

        AF.request(request).responseJSON { response in

            if let error = response.error {
                completionHandler(nil, .error)
                print("Error: \(error)")
            }

            guard let responseData = response.data else {
                completionHandler(nil, .error)
                return
            }

            do {
                let jsonData = try JSONSerialization.jsonObject(
                    with: responseData,
                    options: JSONSerialization.ReadingOptions.allowFragments
                    ) as? [String: Any]

                if let json = jsonData,
                    let status = json["status"] as? String {

                    if status == "success" {
                        if let json = jsonData,
                            let employeesList = json["data"] as? [[String: Any]] {

                            print("JSON: \(json)")
                            self.employeeList = [EmployeeModel]()

                            for employees in employeesList {
                                if let id = employees["id"] as? String,
                                    let employeeName = employees["employee_name"] as? String,
                                    let employeeSalary = employees["employee_salary"] as? String,
                                    let employeeAge = employees["employee_age"] as? String,
                                    let profileImage = employees["employee_age"] as? String {
                                    self.employeeList?.append(EmployeeModel(id: id, employeeName: employeeName, employeeSalary: employeeSalary, employeeAge: employeeAge, profileImage: profileImage))
                                }
                            }

                            completionHandler(.success, nil)
                        }
                    } else {
                        print("Error at server validations ")
                        completionHandler(nil, .error)
                    }
                }
            } catch let jsonError {
                print("Unable to parse json: \(jsonError.localizedDescription)")
                completionHandler(nil, .error)
            }
        }
    }

    func createData(payload: [String: String?], completionHandler: @escaping (Result?, Result?) -> Void) {
        guard let url = URL(string: Constants.baseURL + "create") else {
            return
        }

        var request = URLRequest(url: url)
        request.method = .post

        if let theJSONData = try? JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted) {
            // HTTP Body
            request.httpBody = theJSONData
        }

        AF.request(request).responseJSON { response in
            if let error = response.error {
                print("Error: \(error)")
                completionHandler(nil, .error)
            }

            guard let responseData = response.data else {
                completionHandler(nil, .error)
                return
            }

            do {
                let jsonData = try JSONSerialization.jsonObject(
                    with: responseData,
                    options: JSONSerialization.ReadingOptions.allowFragments
                    ) as? [String: Any]

                if let json = jsonData,
                    let status = json["status"] as? String {
                    print(json)
                    if status == "success" {
                        DispatchQueue.main.async {
                            completionHandler(.success, nil)
                        }
                    } else {
                        print("Error at server validations")
                        completionHandler(nil, .error)
                    }
                }
            } catch let jsonError {
                print("Unable to parse json: \(jsonError.localizedDescription)")
                completionHandler(nil, .error)
            }

            print(responseData)
        }
    }
}
