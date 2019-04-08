//
//  OutputsViewModel.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/8/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

class OutputsViewModel {

    private let networkProvider: MoyaProvider<AnyTarget>
    private let target: AnyTarget

    private lazy var disposeBag = DisposeBag()

    init(target: AnyTarget) {
        self.target = target
        self.networkProvider = MoyaProvider<AnyTarget>()
    }
}
