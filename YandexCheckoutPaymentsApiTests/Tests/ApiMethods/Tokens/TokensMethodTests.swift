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

class TokensMethodTests: ApiMethodTestCase {
    struct TokensResponseSuccess: StubsResponse {}

    func testTokensResponseSuccess() {
        validate(TokensResponseSuccess.self) {
            guard case .right(let response) = $0 else {
                XCTFail("Wrong result")
                return
            }

            XCTAssertEqual(response.paymentToken, "eyJskfjalksjgka", "paymentToken wrong")
        }
    }
}

private extension TokensMethodTests {
    func validate(_ stubsResponse: StubsResponse.Type,
                  verify: @escaping (Result<Tokens>) -> Void) {
        let confirmation = Confirmation(
            type: .redirect,
            returnUrl: "checkout://return"
        )
        let amount = MonetaryAmount(
            value: 0,
            currency: "RUB"
        )
        let tokensRequest = TokensRequest(
            amount: amount,
            tmxSessionId: "",
            confirmation: confirmation,
            savePaymentMethod: true
        )
        let method = Tokens.Method(
            oauthToken: "",
            tokensRequest: tokensRequest
        )
        validate(method, stubsResponse, TokensMethodTests.self, verify: verify)
    }
}
