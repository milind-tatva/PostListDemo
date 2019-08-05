//
//  APIError.swift
//  PostListDemo
//
//  Created by PCQ187 on 05/08/19.
//  Copyright © 2019 PCQ187. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

enum APICallStatus: Error {
    case success
    case failed
    case forbidden
    case serializationFailed
    case offline
    case timeout
    case unknown
    
    var message: String {
        switch self {
        case .success:
            return ""
        case .failed:
            return "API failed"
        case .forbidden:
            return "Forbidden API."
        case .serializationFailed:
            return "response is not serialized."
        case .offline:
            return "Internet is not available."
        case .timeout:
            return "API timeout."
        case .unknown:
            return "server error"
        }
    }
}

class APIError {
    
    var isCritical: Bool = false
    var message: String = String()
    var callStatus: APICallStatus = .unknown
    
    init() {
        
    }
    init(critical:Bool, callStatus: APICallStatus = .unknown) {
        self.isCritical = critical
        self.callStatus = callStatus
        self.message = callStatus.message
    }
    convenience init(status:APICallStatus) {
        switch status {
        case .success:
            self.init()
        case .failed:
            self.init(critical: false, callStatus: status)
        case .forbidden:
            self.init(critical: false, callStatus: status)
        case .serializationFailed:
            self.init(critical: false, callStatus: status)
        case .offline:
            self.init(critical: false, callStatus: status)
        case .timeout:
            self.init(critical: false, callStatus: status)
        case .unknown:
            self.init(critical: false, callStatus: status)
        }
    }
}
