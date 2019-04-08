//
//  OutputsViewController.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/8/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import UIKit
import RxSwift

class OutputsViewController: UIViewController, Bindable {

    var viewModel: OutputsViewModel!
    private var resultTextView: UITextView!

    private lazy var disposeBag = DisposeBag()

    override func loadView() {
        resultTextView = UITextView()
        resultTextView.font = .systemFont(ofSize: 14)
        resultTextView.isEditable = false
        resultTextView.isScrollEnabled = true
        self.view = resultTextView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.sendAPIRequest()
    }

    func bindViewModel() {
        viewModel.result
            .asDriver()
            .drive(onNext: { [weak self] data in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.resultTextView.text = String(data: data, encoding: .utf8)
            })
            .disposed(by: disposeBag)
    }
}
