//
//  Navigator.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/8/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import UIKit

protocol Navigator {
    associatedtype Destination
    func navigate(to destination: Destination)
}

/// The main navigator.
class AppNavigator: Navigator {

    enum Destination {
        case inputs
        case outputs(target: AnyTarget)
    }

    private(set) weak var navigationController: UINavigationController?

    convenience init() {
        let navigationController = UINavigationController()
        self.init(navigationController: navigationController)
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigate(to: .inputs)
    }

    func navigate(to destination: Destination) {
        let destinationController = makeViewController(for: destination)
        navigationController?.pushViewController(destinationController, animated: true)
    }

    private func makeViewController(for destination: Destination) -> UIViewController {

        func make<U: UIViewController, V>(viewModel: V) -> U where U: Bindable, U.ViewModelType == V {
            let viewController = U()
            viewController.bind(to: viewModel)
            return viewController
        }

        switch destination {
        case .inputs:
            let viewModel = InputsViewModel()
            let viewController: InputsViewController = make(viewModel: viewModel)
            return viewController

        case .outputs(let target):
            let viewModel = OutputsViewModel(target: target)
            let viewController: OutputsViewController = make(viewModel: viewModel)
            return viewController
        }
    }
}
