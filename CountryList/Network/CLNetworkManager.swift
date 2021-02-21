//
//  DCGNetworkManager.swift
//  CountryList
//
//  Created by Amit Kumar Gupta on 20/02/21.
//  Copyright © 2019 Harman Connected Services. All rights reserved.
//

import Foundation
import Alamofire

public typealias JSON = [String: Any]

class CLNetworkManager {

    static let shared = CLNetworkManager()
    private init() {}

    func fetchCountries (completionHandler: @escaping (Alamofire.Result<[CountryDetail]>) -> Void) {
        let url = "https://connect.mindbodyonline.com/rest/worldregions/country"
        let networkOp = CLNetworkOperation<[CountryDetail]>()
        networkOp.performOperation(url, type: .get, completionHandler: completionHandler)
    }

    func fetchProvinces (for country: Int, completionHandler: @escaping (Alamofire.Result<[ProvinceDetail]>) -> Void) {
        let url = "https://connect.mindbodyonline.com/rest/worldregions/country/\(country)/province"
        let networkOp = CLNetworkOperation<[ProvinceDetail]>()
        networkOp.performOperation(url, type: .get, completionHandler: completionHandler)
    }
}
