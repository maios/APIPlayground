//
//  Bindable.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/8/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import UIKit

/// A type that can be binded to a view model.
protocol Bindable: class {
    associatedtype ViewModelType
    /// The view model to bind to.
    var viewModel: ViewModelType! { get set }
    /// Connect to the view model inputs and outputs
    func bindViewModel()
}

extension Bindable where Self: UIViewController {

    func bind(to viewModel: ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
