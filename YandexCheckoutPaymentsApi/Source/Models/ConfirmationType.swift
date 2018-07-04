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

/// Type of custom payment confirmation process.
/// Read more about the scenarios of [confirmation of payment](https://kassa.yandex.ru/docs/guides/#confirmation)
/// by the buyer.
public struct ConfirmationType: OptionSet, Codable {

    public private(set) var rawValue: Set<String>

    /// You need to send the user to the partner page.
    public static let redirect = ConfirmationType(rawValue: ["redirect"])

    public init(rawValue: Set<String>) {
        self.rawValue = rawValue
    }

    init?(rawValue: Set<String>?) {
        guard let rawValue = rawValue else { return nil }
        self.init(rawValue: rawValue)
    }

    /// Creates a new instance by decoding from the given decoder.
    /// This initializer throws an error if reading from the decoder fails,
    /// or if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameters:
    ///   - decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Set<String>.self)
        self.init(rawValue: rawValue)
    }

    // MARK: - Encodable

    /// Encodes this value into the given encoder.
    /// If the value fails to encode anything, encoder will encode an empty keyed container in its place.
    /// This function throws an error if any values are invalid for the given encoder’s format.
    ///
    /// - Parameters:
    ///   - encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    // MARK: - SetAlgebra

    public init() {
        self.init(rawValue: Set())
    }

    public mutating func formUnion(_ other: ConfirmationType) {
        rawValue = Set(rawValue).union(other.rawValue)
    }

    public mutating func formIntersection(_ other: ConfirmationType) {
        rawValue = Set(rawValue).intersection(other.rawValue)
    }

    public mutating func formSymmetricDifference(_ other: ConfirmationType) {
        rawValue = Set(rawValue).symmetricDifference(other.rawValue)
    }

    // MARK: - Equatable

    public static func == (lhs: ConfirmationType, rhs: ConfirmationType) -> Bool {
        return Set(lhs.rawValue) == Set(rhs.rawValue)
    }
}
