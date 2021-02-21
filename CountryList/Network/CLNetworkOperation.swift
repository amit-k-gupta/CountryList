//
//  DCGNetworkOperation.swift
//  DiningClubGroup Staging
//
//  Created by Amit Kumar Gupta on 07/04/19.
//  Copyright © 2019 Harman Connected Services. All rights reserved.
//

import Foundation
import Alamofire

class DCGNetworkOperation<T>: DCGBaseOperation where T: Codable {

    var isEventCapture = false

    func performOperation (_ url: String, type: Alamofire.HTTPMethod, params: JSON? = nil, completionHandler: @escaping (Alamofire.Result<T>) -> Void) {
        let theHeader = isEventCapture ? self.eventToken! : self.jwtToken!
        Alamofire.request(url, method: type, parameters: params, encoding: JSONEncoding.default, headers: theHeader).responseData( completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                if let statusCode = response.response?.statusCode {
                    if statusCode >= 200, statusCode < 300 {
                        if !data.isEmpty {
                            do {
                                let decoder = JSONDecoder()
                                decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
                                let user = try decoder.decode(T.self, from: data)
                                completionHandler(Alamofire.Result.success(user))

                            } catch let error {
                                print(error)
                                completionHandler(Alamofire.Result.failure(NetworkError.incorrectDataReturned))
                            }
                        } else {
                            completionHandler(Alamofire.Result.success(true as! T))
                        }
                    } else {
                        completionHandler(Alamofire.Result.failure(NetworkError.custom(message: "\(statusCode)")))
                    }
                }
            case .failure(let error) :
                print(error)
                completionHandler(Alamofire.Result.failure(error))
            }
        })
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    static let defaultFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        return formatter
    }()
}
