//
//  DCGNetworkManager.swift
//  DiningClubGroup
//
//  Created by Amit Kumar Gupta on 06/04/19.
//  Copyright © 2019 Harman Connected Services. All rights reserved.
//

import Foundation
import Alamofire

public typealias JSON = [String: Any]

class DCGNetworkManager {

    static let shared = DCGNetworkManager()
    private let buildSettingsEnvironment: BuildSettingsEnvironmentProtocol = BuildSettings()
    private init() {}

    func fetchRestrauntUsage(completionHandler: @escaping (Alamofire.Result<AllUsages>) -> Void) {
        let url = buildSettingsEnvironment.membershipBaseUrlPath.appending("/usage")
        let networkOp = DCGNetworkOperation<AllUsages>()
        networkOp.performOperation(url, type: .get, completionHandler: completionHandler)
    }

    func fetchRestrauntDetails (for id: String, completionHandler: @escaping (Alamofire.Result<RestaurantDetails>) -> Void) {
        let url = buildSettingsEnvironment.restaurantBaseUrlPath.appending(String(format: "restaurant/%@?includeDeleted=1", id))
        let networkOp = DCGNetworkOperation<RestaurantDetails>()
        networkOp.performOperation(url, type: .get, completionHandler: completionHandler)
    }

    func fetchRestraunts (url: String, completionHandler: @escaping (Alamofire.Result<[RestaurantDetails]>) -> Void) {
        let networkOp = DCGNetworkOperation<[RestaurantDetails]>()
        networkOp.performOperation(url, type: .get, completionHandler: completionHandler)
    }

    func fetchDominosCode (param: JSON, completionHandler: @escaping (Alamofire.Result<ChainCode>) -> Void) {
        let url = buildSettingsEnvironment.membershipBaseUrlPath.appending("/customer/requestRestaurantRedemptionCode")
        let networkOp = DCGNetworkOperation<ChainCode>()
        networkOp.performOperation(url, type: .post, params: param, completionHandler: completionHandler)
    }

    func deleteUsage (id: String, completionHandler: @escaping (Alamofire.Result<Bool>) -> Void) {
        let url = buildSettingsEnvironment.membershipBaseUrlPath.appending("/usage/\(id)")
        let networkOp = DCGNetworkOperation<Bool>()
        networkOp.performOperation(url, type: .delete, params: nil, completionHandler: completionHandler)
    }

    func fetchFavouriteRestaurants(completionHandler: @escaping (Alamofire.Result<[Favourite]>) -> Void) {
        let url = buildSettingsEnvironment.membershipBaseUrlPath.appending("/favourite")
        let networkOp = DCGNetworkOperation<[Favourite]>()
        networkOp.performOperation(url, type: .get, completionHandler: completionHandler)
    }

    func unFavouriteRestaurant (id: String, completionHandler: @escaping (Alamofire.Result<Bool>) -> Void) {
        let url = buildSettingsEnvironment.membershipBaseUrlPath.appending("/favourite/restaurant/\(id)")
        let networkOp = DCGNetworkOperation<Bool>()
        networkOp.performOperation(url, type: .delete, params: nil, completionHandler: completionHandler)
    }

    func makeRestaurantAsFavourite (param: JSON, completionHandler: @escaping (Alamofire.Result<Bool>) -> Void) {
        let url = buildSettingsEnvironment.membershipBaseUrlPath.appending("/favourite")
        let networkOp = DCGNetworkOperation<Bool>()
        networkOp.performOperation(url, type: .post, params: param, completionHandler: completionHandler)
    }

    func fetchTermsAndConditions (completionHandler: @escaping (Alamofire.Result<MembershipTerms>) -> Void) {
        let url = buildSettingsEnvironment.membershipBaseUrlPath.appending("/terms/channel/b2c")
        let networkOp = DCGNetworkOperation<MembershipTerms>()
        networkOp.performOperation(url, type: .get, params: nil, completionHandler: completionHandler)
    }

    func postEvent (param: JSON, completionHandler: @escaping (Alamofire.Result<Bool>) -> Void) {
        let networkOp = DCGNetworkOperation<Bool>()
        networkOp.isEventCapture = true
        networkOp.performOperation(BuildSettings().eventURL, type: .post, params: param, completionHandler: completionHandler)
    }
}
