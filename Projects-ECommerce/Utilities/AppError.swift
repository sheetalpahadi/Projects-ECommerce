//
//  AppError.swift
//  Projects-ECommerce
//
//  Created by Admin on 16/08/25.
//

import Foundation

enum AppError: Error {
    case badRequest
    case requestTimeOut
    case invalidResponse
    case unknownServerError
    case invalidUrl
    case apiError(code: Int, errorMessage: String)
    case parsingError
    //to handle error messages and status codes if api sends error in repsonse
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badRequest: String(localized: "It was a bad request")
        case .requestTimeOut: String(localized: "Taking time to load")
        case .invalidResponse: String(localized: "Invalid response received")
        case .unknownServerError: String(localized: "Some unknown issue with the server")
        case .invalidUrl: String(localized: "Invalid URL was called")
        case .apiError(let code, let errorMessage):
            String(localized: "\(errorMessage)")
        case .parsingError: String(localized: "Parsing error")
        }
    }
    
    var failureReason: String? {
        switch self {
        case .badRequest: String(localized: "Error Reason - It was a bad request")
        case .requestTimeOut: String(localized: "Error Reason - Taking time to load")
        case .invalidResponse: String(localized: "Error Reason - Invalid response received")
        case .unknownServerError: String(localized: "Error Reason  - Some unknown issue with the server")
        case .invalidUrl: String(localized: "Error Reason  - Invalid URL was called")
        case .apiError(let code, let errorMessage):
            String(localized: "Error Reason - \(errorMessage)")
        case .parsingError: String(localized: "Parsing error")
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .badRequest: String(localized: "Try checking the request")
        case .requestTimeOut: String(localized: "Check with server admin")
        case .invalidResponse: String(localized: "Check parsing issues")
        case .unknownServerError: String(localized: "Please try again later")
        case .invalidUrl: String(localized: "Check your URL")
        case .apiError(let code, let errorMessage):
            String(localized: "Suggestion - \(errorMessage)")
        case .parsingError: String(localized: "Parsing error")
        }
    }
}
