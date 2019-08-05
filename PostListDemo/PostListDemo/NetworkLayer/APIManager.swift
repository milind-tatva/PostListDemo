//
//  APIManager.swift
//  PostListDemo
//
//  Created by PCQ187 on 05/08/19.
//  Copyright © 2019 PCQ187. All rights reserved.
//

import SwiftyJSON
import Alamofire

class APIManager {
    
    private let header = [
        "Content-Type":"application/json"
    ]
    
    static let shared = APIManager()
    
    private let sessionManager : SessionManager!
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.httpMaximumConnectionsPerHost = 10
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    
    
    
    func callRequest(_ router: Router,
                     onSuccess success: @escaping (_ response: BaseResponse) -> Void,
                     onFailure failure: @escaping (_ error: APIError) -> Void) {
        
        guard AppDelegate.isReachable == true else {
            let apiError = APIError(status: .offline)
            failure(apiError)
            return
        }
        
        let path = router.path.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        
        var parameter = router.parameters
        if router.parameters == nil {
            parameter = [:]
        }
        
        //Update encoding here
        var encoding: ParameterEncoding = JSONEncoding.default
        if router.method == .get {
            encoding = URLEncoding.default
        }
        
        self.sessionManager.request(path!,
                                    method: router.method,
                                    parameters: parameter!,
                                    encoding: encoding, headers: header).responseJSON { response  in
                                        
                                        guard response.result.value != nil else{
                                            return
                                        }
                                        
                                        switch response.result {
                                        case .success:
                                            let apiResponse = BaseResponse(response: response)
                                            if apiResponse.success {
                                                success(apiResponse)
                                            } else {
                                                let apiError = APIError(status: .failed)
                                                failure(apiError)
                                            }
                                            break
                                        case .failure(let error):
                                            print("Error: \(error)")
                                            let apiError = APIError(status: .failed)
                                            failure(apiError)
                                            break
                                        }
        }
    }
    
    
}
