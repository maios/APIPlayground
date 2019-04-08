//
//  InputsViewModel.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/6/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift
import RxCocoa

class InputsViewModel {

    private static let defaultTarget = AnyTarget(baseURL: URL(string: "https://api.thecatapi.com/v1/")!,
                                                 path: "images/search",
                                                 method: .get,
                                                 parameters: ["limit": 10],
                                                 headers: ["x-api-key": "d6d5515a-e1bc-4588-b01b-298e5d3da4f9"])

    let baseURLInput: BehaviorRelay<URL?> = .init(value: InputsViewModel.defaultTarget.baseURL)
    let pathInput: BehaviorRelay<String?> = .init(value: InputsViewModel.defaultTarget.path)
    let httpMethodInput: BehaviorRelay<HTTPMethod> = .init(value: InputsViewModel.defaultTarget.method)
    let parametersInput: BehaviorRelay<Parameters?> = .init(value: InputsViewModel.defaultTarget.parameters)
    let headersInput: BehaviorRelay<[String: String]?> = .init(value: InputsViewModel.defaultTarget.headers)

    let tryOutTrigger: PublishSubject<Void> = .init()

    private let dispobseBag = DisposeBag()

    init() {
        let allInputs = Observable
            .combineLatest(baseURLInput.unwrap(),
                           pathInput.unwrap(),
                           httpMethodInput,
                           parametersInput,
                           headersInput)
            .map(AnyTarget.init)
        tryOutTrigger
            .asObserver()
            .observeOn(MainScheduler.instance)
            .withLatestFrom(allInputs)
            .subscribe(onNext: perform(target:))
            .disposed(by: dispobseBag)
    }

    private func perform(target: AnyTarget) {

    }
}
