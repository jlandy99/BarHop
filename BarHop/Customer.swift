//
//  Customer.swift
//  MySampleApp
//
//
// Copyright 2018 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.21
//

import Foundation
import UIKit
import AWSDynamoDB

class Customer: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    
    @objc var _userId: String?
    @objc var _tripsTaken: NSNumber?
    @objc var _activeTrips: Set<String>?
    @objc var _braintreeId: NSNumber?
    
    class func dynamoDBTableName() -> String {

        return "barhop-mobilehub-1353656554-Customers"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_tripsTaken" : "TripsTaken",
               "_activeTrips" : "ActiveTrips",
               "_braintreeId" : "BraintreeId",
        ]
    }
}
