//
//  EmployeeModel.swift
//  AssignmentKrantiTech
//
//  Created by Bhushan Udawant on 10/04/20.
//  Copyright © 2020 Bhushan Udawant. All rights reserved.
//

import Foundation

struct EmployeeModel {
    var id: String
    var employeeName: String
    var employeeSalary: String
    var employeeAge: String
    var profileImage: String

    init(id: String, employeeName: String, employeeSalary: String, employeeAge: String, profileImage: String) {
        self.id = id
        self.employeeName = employeeName
        self.employeeSalary = employeeSalary
        self.employeeAge = employeeAge
        self.profileImage = profileImage
    }
}
