//
//  AnyTarget.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/6/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import Alamofire
import Foundation
import Moya

struct AnyTarget: TargetType {
    let baseURL: URL
    let path: String
    let method: HTTPMethod
    let parameters: Parameters?
    let headers: [String : String]?

    let sampleData: Data = Data()

    var task: Task {
        return .requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.default)
    }
}
