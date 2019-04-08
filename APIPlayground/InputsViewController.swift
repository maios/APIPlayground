//
//  InputsViewController.swift
//  APIPlayground
//
//  Created by Mai Mai on 4/6/19.
//  Copyright © 2019 maimai. All rights reserved.
//

import Alamofire
import Eureka
import RxCocoa
import RxSwift
import UIKit

class InputsViewController: FormViewController, Bindable {

    var viewModel: InputsViewModel!
    private var baseURLRow: URLRow!
    private var pathRow: TextRow!
    private var httpMethodPickerRow: PickerInlineRow<HTTPMethod>!
    private var parametersSection: MultivaluedSection!
    private var headersSection: MultivaluedSection!
    private var tryOutButtonRow: ButtonRow!

    private lazy var disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()

        baseURLRow = URLRow()
        pathRow = TextRow()
        httpMethodPickerRow = PickerInlineRow<HTTPMethod>() { pickerRow in
            pickerRow.title = "HTTP Method"
            pickerRow.options = HTTPMethod.allCases
            pickerRow.displayValueFor = { $0?.rawValue.uppercased() }
        }
        tryOutButtonRow = ButtonRow() { buttonRow in
            buttonRow.title = "Try out!"
        }

        let makeMultivaluedSection: (_ header: String) -> MultivaluedSection = { header in
            let section = MultivaluedSection(multivaluedOptions: [.Insert, .Delete], header: header) { section in
                section.multivaluedRowToInsertAt = { _ in
                    return TextRow() { row in
                        row.placeholder = "key=value"
                        row.cell.textField.autocapitalizationType = .none
                    }
                }
            }
            return section
        }

        parametersSection = makeMultivaluedSection("Parameters")
        headersSection = makeMultivaluedSection("Headers")

        // Build form
        form +++ Section("Base URL") <<< baseURLRow
            +++ Section("API Path") <<< pathRow
            +++ Section() <<< httpMethodPickerRow
            +++ parametersSection
            +++ headersSection
            +++ Section() <<< tryOutButtonRow
    }

    func bindViewModel() {
        [baseURLRow.rx.value <-> viewModel.baseURLInput,
         pathRow.rx.value <-> viewModel.pathInput].forEach(disposeBag.insert)

        httpMethodPickerRow.value = viewModel.httpMethodInput.value
        httpMethodPickerRow.onChange { [unowned self] pickerRow in
            self.viewModel.httpMethodInput.accept(pickerRow.value!)
        }

        let toTextRows: ([String: Any]) -> [TextRow] = {
            return $0.reduce(into: []) { (result, item) in
                let row = TextRow() { $0.value = "\(item.key)=\(item.value)" }
                result.append(row)
            }
        }

        toTextRows(viewModel.parametersInput.value ?? [:]).forEach(parametersSection.append)
        toTextRows(viewModel.headersInput.value ?? [:]).forEach(headersSection.append)

        tryOutButtonRow.onCellSelection { [unowned self] (_, _) in
            let parameters: Parameters = self.parametersSection.allRows.reduce(into: [:]) { (result, row) in
                let components = (row as? TextRow)?.value?.components(separatedBy: "=") ?? []
                if components.count == 2 {
                    result[components.first!] = components.last!
                }
            }
            let header: [String: String] = self.headersSection.allRows.reduce(into: [:]) { (result, row) in
                let components = (row as? TextRow)?.value?.components(separatedBy: "=") ?? []
                if components.count == 2 {
                    result[components.first!] = components.last!
                }
            }
            self.viewModel.parametersInput.accept(parameters)
            self.viewModel.headersInput.accept(header)

            self.viewModel.tryOutTrigger.onNext(())
        }
    }
}
