/*
 * The MIT License
 *
 * Copyright (c) 2007—2018 NBCO Yandex.Money LLC
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

class PaymentOptionsMethodTests: ApiMethodTestCase {

    struct PaymentOptionsResponseSuccess: StubsResponse {}
    struct PaymentOptionsResponseEmpty: StubsResponse {}

    func testPaymentOptionsResponseSuccess() {
        validate(PaymentOptionsResponseSuccess.self) {
            guard case .right(let response) = $0 else {
                XCTFail("Wrong result")
                return
            }

            XCTAssertEqual(response.items.count, 6, "response.items.count wrong")
        }
    }

    func testPaymentOptionsResponseEmpty() {
        validate(PaymentOptionsResponseEmpty.self) {
            guard case .right(let response) = $0 else {
                XCTFail("Wrong result")
                return
            }

            XCTAssertEqual(response.items.count, 0, "response.items.count wrong")
        }
    }
}

private extension PaymentOptionsMethodTests {
    func validate(_ stubsResponse: StubsResponse.Type,
                  verify: @escaping (Result<PaymentOptions>) -> Void) {
        let method = PaymentOptions.Method(oauthToken: "",
                                           passportAuthorization: "",
                                           gatewayId: "",
                                           amount: "",
                                           currency: "")
        validate(method, stubsResponse, PaymentOptionsMethodTests.self, verify: verify)
    }
}
