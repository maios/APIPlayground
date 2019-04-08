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

typealias ParameterRow = SplitRow<TextRow, TextRow>
typealias HeaderRow = SplitRow<TextRow, TextRow>

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

        baseURLRow = makeFieldRow()
        pathRow = makeFieldRow()
        httpMethodPickerRow = PickerInlineRow<HTTPMethod>() { pickerRow in
            pickerRow.title = "HTTP Method"
            pickerRow.options = HTTPMethod.allCases
            pickerRow.displayValueFor = { $0?.rawValue.uppercased() }
        }
        tryOutButtonRow = ButtonRow() { buttonRow in
            buttonRow.title = "Try out!"
        }

        let makeMultivaluedSection: (_ header: String) -> MultivaluedSection = { header in
            let section = MultivaluedSection(header: header) { section in
                section.multivaluedRowToInsertAt = { _ in
                    return SplitRow<TextRow, TextRow>() {
                        $0.rowLeftPercentage = 0.3
                        $0.rowLeft = self.makeFieldRow(placeholder: "key")
                        $0.rowRight = self.makeFieldRow(placeholder: "value")
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

        let toSplitRows: ([String: Any]) -> [SplitRow<TextRow, TextRow>] = {
            return $0.reduce(into: []) { (result, item) in
                let row = SplitRow<TextRow, TextRow>() {
                    $0.rowLeft = self.makeFieldRow(value: item.key)
                    $0.rowRight = self.makeFieldRow(value: "\(item.value)")
                }
                result.append(row)
            }
        }

        toSplitRows(viewModel.parametersInput.value ?? [:]).forEach { parametersSection.insert($0, at: 0) }
        toSplitRows(viewModel.headersInput.value ?? [:]).forEach { headersSection.insert($0, at: 0) }

        tryOutButtonRow.onCellSelection { [unowned self] (_, _) in
            let parameters: Parameters = self.parametersSection.allRows
                .compactMap { $0 as? ParameterRow }
                .reduce(into: [:]) { (result, row) in
                    guard let key = row.value?.left, let value = row.value?.right else {
                        return
                    }
                    result[key] = value
                }
            let header: [String: String] = self.headersSection.allRows
                .compactMap { $0 as? HeaderRow }
                .reduce(into: [:]) { (result, row) in
                    guard let key = row.value?.left, let value = row.value?.right else {
                        return
                    }
                    result[key] = value
                }
            self.viewModel.parametersInput.accept(parameters)
            self.viewModel.headersInput.accept(header)

            self.viewModel.tryOutTrigger.onNext(())
        }
    }

    // MARK: Helper

    private func makeFieldRow<Cell, Row>(placeholder: String? = nil,
                                         value: Cell.Value? = nil) -> Row where Cell: BaseCell & TextFieldCell, Row: FieldRow<Cell> {
            let row = Row(tag: nil)
            row.placeholder = placeholder
            row.value = value
            row.cell.textField.autocapitalizationType = .none
            return row
    }
}
