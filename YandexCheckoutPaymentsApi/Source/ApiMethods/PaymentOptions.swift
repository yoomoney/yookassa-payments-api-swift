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

import Foundation
import FunctionalSwift
import YandexMoneyCoreApi

/// Response for payment options.
public struct PaymentOptions {

    /// List of payment methods. If there is no suitable way, the list will be empty.
    public let items: [PaymentOption]

    /// Creates instance of `PaymentOptions`.
    ///
    /// - Parameters:
    ///   - items: List of payment methods. If there is no suitable way, the list will be empty.
    ///
    /// - Returns: Instance of `PaymentOptions`.
    public init(items: [PaymentOption]) {
        self.items = items
    }

    /// API method for `PaymentOptions`.
    public struct Method {

        /// Client application key.
        public let oauthToken: String

        /// Yandex user authorization (OAuth-token).
        public let passportAuthorization: String?

        /// Gateway ID. Setup, is provided at check in Yandex store.
        /// The cashier at the division of payment flows within a single account.
        public let gatewayId: String?

        /// Payment amount, decimal number with a fixed point in the string view.
        public let amount: String?

        /// ISO-4217 3-alpha character code of payment currency.
        public let currency: String?

        /// Creates instance of API method for `PaymentOptions`.
        ///
        /// - Parameters:
        ///   - oauthToken: Client application key.
        ///   - passportAuthorization: Yandex user authorization (OAuth-token).
        ///   - gatewayId: Gateway ID. Setup, is provided at check in Yandex store.
        ///   -            The cashier at the division of payment flows within a single account.
        ///   - amount: Payment amount, decimal number with a fixed point in the string view.
        ///   - currency: ISO-4217 3-alpha character code of payment currency.
        ///
        /// - Returns: Instance of API method for `PaymentOptions`.
        public init(oauthToken: String,
                    passportAuthorization: String?,
                    gatewayId: String?,
                    amount: String?,
                    currency: String?) {
            self.oauthToken = oauthToken
            self.passportAuthorization = passportAuthorization
            self.gatewayId = gatewayId
            self.amount = amount
            self.currency = currency
        }
    }
}

// MARK: - Decodable

extension PaymentOptions: Decodable {

    /// Creates a new instance by decoding from the given decoder.
    /// This initializer throws an error if reading from the decoder fails,
    /// or if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameters:
    ///   - decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var itemsContainer = try container.nestedUnkeyedContainer(forKey: .items)
        var items: [PaymentOption] = []
        items.reserveCapacity(itemsContainer.count ?? 0)

        while itemsContainer.isAtEnd == false {

            if let item = try? itemsContainer.decode(PaymentInstrumentYandexMoneyWallet.self) {
                items.append(item)
            } else if let item = try? itemsContainer.decode(PaymentInstrumentYandexMoneyLinkedBankCard.self) {
                items.append(item)
            } else if let item = try? itemsContainer.decode(PaymentOptionYandexMoneyInstrument.self) {
                items.append(item)
            } else if let item = try? itemsContainer.decode(PaymentOption.self) {
                items.append(item)
            } else {
                _ = try? itemsContainer.decode(AnyCodable.self)
            }
        }

        self.init(items: items)
    }

    private enum CodingKeys: String, CodingKey {
        case items
    }

    private struct AnyCodable: Codable {}
}

// MARK: - PaymentsApiResponse

extension PaymentOptions: PaymentsApiResponse {}

// MARK: - JsonApiResponse

extension PaymentOptions: JsonApiResponse {}

// MARK: - ApiMethod

extension PaymentOptions.Method: ApiMethod {
    public typealias Response = PaymentOptions

    public var hostProviderKey: String {
        return Constants.paymentsApiMethodsKey
    }

    public var httpMethod: HTTPMethod {
        return .get
    }

    public var parametersEncoding: ParametersEncoding {
        return QueryParametersEncoder()
    }

    public var headers: Headers {
        let requiredHeaders = Headers([
             AuthorizationConstants.authorization: AuthorizationConstants.basicAuthorizationPrefix + oauthToken,
        ])

        var headers = requiredHeaders
        if let passportAuthorization = passportAuthorization {
            headers = headers.mappend(Headers([
                AuthorizationConstants.passportAuthorization: passportAuthorization,
            ]))
        }
        return headers
    }

    public func urlInfo(from hostProvider: HostProvider) throws -> URLInfo {
        return .components(host: try hostProvider.host(for: hostProviderKey),
                           path: "/frontend-api/v3/payment_options")
    }
}

// MARK: - Method: Encodable, Decodable

extension PaymentOptions.Method: Encodable, Decodable {

    /// Encodes this value into the given encoder.
    /// If the value fails to encode anything, encoder will encode an empty keyed container in its place.
    /// This function throws an error if any values are invalid for the given encoder’s format.
    ///
    /// - Parameters:
    ///   - encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(gatewayId, forKey: .gatewayId)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(currency, forKey: .currency)
    }

    /// Creates a new instance by decoding from the given decoder.
    /// This initializer throws an error if reading from the decoder fails,
    /// or if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameters:
    ///   - decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gatewayId = try container.decodeIfPresent(String.self, forKey: .gatewayId)
        let amount = try container.decodeIfPresent(String.self, forKey: .amount)
        let currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.init(oauthToken: "",
                  passportAuthorization: "",
                  gatewayId: gatewayId,
                  amount: amount,
                  currency: currency)
    }

    private enum CodingKeys: String, CodingKey {
        case gatewayId = "gateway_id"
        case amount
        case currency
    }
}
