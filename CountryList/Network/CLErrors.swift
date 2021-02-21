////
//  Errors.swift
//  Hi Mum Said Dad
//
//  Created by Hayden Young on 15/11/2017.
//  Copyright © 2017 Hi Mum Said Dad. All rights reserved.
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

    /// Authentication required
    case authenticationRequired

    /// Customer access token is invalid. Somebody logged in on another device.
    case invalidAccessToken

    /// Resource was not recognized
    case notRecognized

    /// Resource not found
    case resourceNotFound

    /// Request was aborted
    case aborted

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
        case 401:
            self = .authenticationRequired
        case 403:
            self = .invalidAccessToken
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
            return L10n.networkErrorProblem
        case .notConnectedToInternet:
            return L10n.networkErrorNotConnectedToInternetTitle
        case .notReachedServer:
            return L10n.networkErrorServiceTimedOutTitle
        case .serviceUnavailable:
            return L10n.networkErrorServiceUnavailableTitle
        case .incorrectDataReturned:
            return L10n.networkErrorIncorrectDataReturned
        case .authenticationRequired:
            return L10n.networkErrorAuthenticationRequired
        case .invalidAccessToken:
            return L10n.networkErrorInvalidTokenTitle
        case .resourceNotFound:
            return L10n.networkErrorResourceNotFound
        case .notRecognized:
            return L10n.networkErrorResourceNotFound
        case .aborted:
            return L10n.networkErrorIncorrectDataReturned
        case .custom(let message):
            return message.isEmpty ? L10n.networkErrorProblem : message
        }
    }

    public var description: String {
        switch self {
        case .unknown:
            return L10n.networkErrorProblem
        case .notConnectedToInternet:
            return L10n.networkErrorNotConnectedToInternetBody
        case .notReachedServer:
            return L10n.networkErrorServiceTimedOutBody
        case .serviceUnavailable:
            return L10n.networkErrorServiceUnavailableBody
        case .incorrectDataReturned:
            return L10n.networkErrorIncorrectDataReturned
        case .authenticationRequired:
            return L10n.networkErrorAuthenticationRequired
        case .invalidAccessToken:
            return L10n.networkErrorInvalidTokenBody
        case .resourceNotFound:
            return L10n.networkErrorResourceNotFound
        case .notRecognized:
            return L10n.networkErrorResourceNotFound
        case .aborted:
            return L10n.networkErrorIncorrectDataReturned
        case .custom(let message):
            return message.isEmpty ? L10n.networkErrorProblem : message
        }
    }

    public var localizedDescription: String {
        return description
    }
}
