//
//  Eureka+Rx.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/6/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import Eureka
import RxCocoa
import RxSwift

extension BaseRow: ReactiveCompatible {}

extension Reactive where Base: BaseRow, Base: RowType {

    var value: ControlProperty<Base.Cell.Value?> {
        let source = Observable<Base.Cell.Value?>.create { [weak base] observer in
            if let strongBase = base  {
                observer.onNext(strongBase.value)
                strongBase.onChange { row in
                    observer.onNext(row.value)
                }
            }
            return Disposables.create(with: observer.onCompleted)
        }
        let bindingObserver = Binder(base) { (row, value) in
            row.value = value
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}
