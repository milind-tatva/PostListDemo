//
//  Router.swift
//  PostListDemo
//
//  Created by PCQ187 on 05/08/19.
//  Copyright © 2019 PCQ187. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

protocol IsJsonable {
    init?(parameter: JSON)
}

protocol Routable {
    var path        : String { get }
    var method      : HTTPMethod { get }
    var parameters  : Parameters? { get }
    var type        : IsJsonable.Type? { get }
    var responseDataKey     : String? { get }
}


enum Router: Routable {
    var baseURL : String {
        return "https://hn.algolia.com/api/v1/"
    }
    
    case getPostLists(Int)
}

extension Router {
    var apiKeyWord: String {
        switch self {
        case .getPostLists(_):
            return "search_by_date"
        }
    }
    
    var path: String {
        return  self.baseURL + self.apiKeyWord
    }
    
}

extension Router {
    var method: HTTPMethod {
        return .get
    }
}

extension Router {
    var parameters: Parameters? {
        switch self {
        case .getPostLists(let pageNumber):
            return ["tags" : "story",
                    "page" : pageNumber]
        }
    }
}

extension Router {
    var type: IsJsonable.Type? {
        switch self {
        case .getPostLists:
            return PostModel.self
        }
    }
}

extension Router {
    var responseDataKey: String? {
        switch self {
        case .getPostLists:
            return "hits"
        }
    }
}
