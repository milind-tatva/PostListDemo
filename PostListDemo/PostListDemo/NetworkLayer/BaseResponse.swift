//
//  BaseResponse.swift
//  PostListDemo
//
//  Created by PCQ187 on 05/08/19.
//  Copyright © 2019 PCQ187. All rights reserved.
//

import SwiftyJSON
import Alamofire

class BaseResponse {
    
    var success: Bool = false
    var message : String?
    var data : JSON?
    var errors: JSON?
    var totalCount: Int?
    
    init(response:DataResponse<Any>) {
        let jsonResult: JSON = JSON(response.result.value!)
        
        self.message = jsonResult["Message"].stringValue
        
        if !jsonResult["hits"].isEmpty {
            self.data = jsonResult["hits"]
            self.success = true
        }else{
            self.success = false
            self.data = jsonResult
        }
        
        self.totalCount = jsonResult["nbPages"].intValue
        
        if !jsonResult["error"].isEmpty {
            self.success = false
            self.errors = jsonResult["error"]
        }
    }
}
