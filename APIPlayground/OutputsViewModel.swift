//
//  OutputsViewModel.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/8/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import Foundation
import Moya
import RxCocoa
import RxMoya
import RxSwift

class OutputsViewModel {

    let result: BehaviorRelay<Data> = .init(value: Data())

    private let networkProvider: MoyaProvider<AnyTarget>
    private let target: AnyTarget

    private lazy var disposeBag = DisposeBag()

    init(target: AnyTarget) {
        self.target = target
        self.networkProvider = MoyaProvider<AnyTarget>()
    }

    func sendAPIRequest() {
        networkProvider
            .rx
            .request(target)
            .mapJSON(failsOnEmptyData: false)
            .map { json in
                return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            }
            .asObservable()
            .bind(to: result)
            .disposed(by: disposeBag)
    }
}
