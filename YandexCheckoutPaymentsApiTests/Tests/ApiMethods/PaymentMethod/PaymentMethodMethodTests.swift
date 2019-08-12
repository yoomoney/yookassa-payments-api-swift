/*
 * The MIT License
 *
 * Copyright (c) 2007—2019 NBCO Yandex.Money LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import typealias FunctionalSwift.Result
import OHHTTPStubs
import XCTest
@testable import YandexCheckoutPaymentsApi
import YandexMoneyTestInstrumentsApi

class PaymentMethodMethodTests: ApiMethodTestCase {
    struct PaymentMethodResponseSuccess: StubsResponse {}

    func testPaymentMethodResponseSuccess() {
        validate(PaymentMethodResponseSuccess.self) {
            guard case .right(let response) = $0 else {
                XCTFail("Wrong result")
                return
            }

            XCTAssertEqual(response.type, PaymentMethodType.bankCard, "type wrong")
            XCTAssertEqual(response.id, "1da5c87d-0984-50e8-a7f3-8de646dd9ec9", "id wrong")
            XCTAssertEqual(response.saved, true, "saved wrong")
            XCTAssertEqual(response.title, "Основная карта", "title wrong")
            XCTAssertEqual(response.cscRequired, true, "title wrong")

            guard let responseCard = response.card else {
                XCTFail("Card must be")
                return
            }

            let mockCard = PaymentMethodBankCard(
                first6: "427918",
                last4: "7918",
                expiryYear: "2017",
                expiryMonth: "07",
                cardType: .masterCard
            )

            XCTAssertEqual(responseCard, mockCard, "card wrong")
        }
    }
}

private extension PaymentMethodMethodTests {
    func validate(_ stubsResponse: StubsResponse.Type,
                  verify: @escaping (Result<PaymentMethod>) -> Void) {
        let method = PaymentMethod.Method(oauthToken: "", paymentMethodId: "")
        validate(method, stubsResponse, PaymentMethodMethodTests.self, verify: verify)
    }
}
