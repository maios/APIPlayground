//
//  AnyObservable.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/6/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import Foundation
import RxSwift

class AnyObservable<E>: ObservableType {
    private let _subscribe: (AnyObserver<E>) -> Disposable

    init<O>(_ observer: O) where O : ObservableType, O.E == E {
        self._subscribe = observer.subscribe(_:)
    }

    func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, O.E == E {
        return self._subscribe(observer.asObserver())
    }
}
