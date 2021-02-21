////
//  CLErrors.swift
//  CountryList
//
//  Created by Amit Kumar Gupta on 20/02/21.
//  Copyright © 2019 Harman Connected Services. All rights reserved.
//

import Foundation

public protocol ErrorResponseCodeProtocol {
    var responseCode: Int? { get }
    var isResponseSerializationError: Bool { get }
}

public enum NetworkError: Error, CustomStringConvertible {

    /// Unknown or not supported error.
    case unknown

    /// Not connected to the internet.
    case notConnectedToInternet

    /// Cannot reach the server.
    case notReachedServer

    /// Service is temporarily unavailable (status code == 503).
    case serviceUnavailable

    /// Incorrect data returned from the server.
    case incorrectDataReturned

    /// Resource was not recognized
    case notRecognized

    /// Resource not found
    case resourceNotFound

    case custom(message: String)

    init(error: ErrorResponseCodeProtocol) {
        guard let responseCode = error.responseCode else {
            if error.isResponseSerializationError {
                self = .incorrectDataReturned
            } else {
                self = .unknown
            }
            return
        }

        switch responseCode {
        case 400:
            self = .notRecognized
        case 404:
            self = .resourceNotFound
        case 500...599:
            self = .serviceUnavailable
        default:
            if error.isResponseSerializationError {
                self = .incorrectDataReturned
            } else {
                self = .unknown
            }
        }
    }

    public var title: String {
        switch self {
        case .unknown:
            return "There was a problem with your request"
        case .notConnectedToInternet:
            return "Resource Not Found"
        case .notReachedServer:
            return "Service timed out"
        case .serviceUnavailable:
            return "Service temporarily unavailable"
        case .incorrectDataReturned:
            return "Incorrect data returned"
        case .notRecognized:
            return "Resource Not Found"
        case .custom(let message):
            return message.isEmpty ? "There was a problem with your request" : message
        case .resourceNotFound:
            return "Resource Not Found"
        }
    }

    public var description: String {
        switch self {
        case .unknown:
            return "There was a problem with your request"
        case .notConnectedToInternet:
            return "Please reset your connection and try again"
        case .notReachedServer:
            return "Please try again later"
        case .serviceUnavailable:
            return "Please try again shortly."
        case .incorrectDataReturned:
            return "Incorrect data returned"
        case .notRecognized:
            return "Resource Not Found"
        case .custom(let message):
            return message.isEmpty ? "There was a problem with your request" : message
        case .resourceNotFound:
            return "No provinces were found belonging to the selected country!"
        }
    }

    public var localizedDescription: String {
        return description
    }
}
