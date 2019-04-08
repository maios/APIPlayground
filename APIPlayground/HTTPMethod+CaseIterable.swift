//
//  HTTPMethod+CaseIterable.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/6/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import Alamofire
import Foundation

extension HTTPMethod: CaseIterable {

    public static var allCases: [HTTPMethod] {
        return [
            .options,
            .get,
            .head,
            .post,
            .put,
            .patch,
            .delete,
            .trace,
            .connect,
        ]
    }
}
