/*
 * The MIT License
 *
 * Copyright © 2020 NBCO YooMoney LLC
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

import Foundation
import XCTest
@testable import YooKassaPaymentsApi
import YooMoneyTestInstrumentsApi

class PaymentsApiErrorMappingTests: MappingApiModels {
    func testPaymentsApiErrorMapping() {
        guard let paymentsApiError = mockWithType(PaymentsApiError.self) else {
            XCTFail("PaymentsApiError mock not loaded")
            return
        }
        let instance = paymentsApiError.instance
        XCTAssertEqual(instance.id, "ecf255db-cce8-4f15-8fc2-3d7a4678c867", "id is not mapped")
        XCTAssertEqual(instance.type, PaymentErrorType.error, "type is not mapped")
        XCTAssertEqual(instance.description, "Invalid API key provided", "description is not mapped")
        XCTAssertEqual(instance.parameter, "payment_method", "parameter is not mapped")
        XCTAssertEqual(instance.retryAfter, "1800", "retryAfter is not mapped")
        XCTAssertEqual(instance.errorCode, PaymentErrorCode.invalidRequest, "errorCode is not mapped")
    }
}
