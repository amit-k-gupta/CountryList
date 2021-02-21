//
//  CountryDetail.swift
//  CountryList
//
//  Created by Amit Kumar Gupta on 20/02/21.
//

import Foundation

struct CountryDetail: Codable {
    let countryId: Int
    let name: String
    let code: String?
    let phoneCode: String?

    enum CodingKeys: String, CodingKey {
       case countryId   =   "ID"
       case name     =  "Name"
       case code    =   "Code"
       case phoneCode   =   "PhoneCode"
    }
}

struct ProvinceDetail: Codable {
    let provinceId: Int
    let countryCode: String?
    let code: String?
    let name: String

    enum CodingKeys: String, CodingKey {
       case provinceId   =   "ID"
       case name     =  "Name"
       case code    =   "Code"
       case countryCode   =   "CountryCode"
    }
}
