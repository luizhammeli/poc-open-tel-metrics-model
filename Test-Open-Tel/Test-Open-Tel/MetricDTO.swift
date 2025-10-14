//
//  File.swift
//  Test-Open-Tel
//
//  Created by Luiz Diniz Hammerli on 14/10/25.
//

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk

struct MetricDataDTO: Encodable {
    let resource: Resource
    let instrumentationScopeInfo: InstrumentationScopeInfo
    let name: String
    let description: String
    let unit: String
    let type: MetricDataType
    let isMonotonic: Bool
    let aggregationTemporality: AggregationTemporality
    let dataPoints: [DoublePointData]

    func toMetricData() -> MetricData? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONDecoder().decode(MetricData.self, from: data)
    }
}

final class DoublePointDataDTO: Codable {
    let value: Double
    let startEpochNanos: UInt64
    let endEpochNanos: UInt64
    let attributes: [String: OpenTelemetryApi.AttributeValue]
    let exemplars: [DoubleExemplarData]

    init(value: Double, startEpochNanos: UInt64, endEpochNanos: UInt64, attributes: [String: AttributeValue], exemplars: [DoubleExemplarData]) {
        self.value = value
        self.startEpochNanos = startEpochNanos
        self.endEpochNanos = endEpochNanos
        self.attributes = attributes
        self.exemplars = exemplars
    }

    @MainActor
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    func toDoublePointData() -> DoublePointData? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONDecoder().decode(DoublePointData.self, from: data)
    }
}

//class PointDataDTO: Codable {
//    let startEpochNanos: UInt64
//    let endEpochNanos: UInt64
//    let attributes: [String: OpenTelemetryApi.AttributeValue]
//    let exemplars: [DoubleExemplarData]
//
//    init(startEpochNanos: UInt64, endEpochNanos: UInt64, attributes: [String: AttributeValue], exemplars: [DoubleExemplarData]) {
//        self.startEpochNanos = startEpochNanos
//        self.endEpochNanos = endEpochNanos
//        self.attributes = attributes
//        self.exemplars = exemplars
//    }
//
//    func toPointData() -> PointData? {
//        guard let data = try? JSONEncoder().encode(self) else { return nil }
//        return try? JSONDecoder().decode(PointData.self, from: data)
//    }
//}

class DoubleExemplarDataDTO: Codable {
    let filteredAttributes: [String: AttributeValue]
    let epochNanos: UInt64
    let spanContext: OpenTelemetryApi.SpanContext?
    let value: Double

    init(value: Double, epochNanos: UInt64, filteredAttributes: [String: AttributeValue], spanContext: SpanContext? = nil) {
        self.filteredAttributes = filteredAttributes
        self.epochNanos = epochNanos
        self.spanContext = spanContext
        self.value = value
    }

    func toExemplarData() -> DoubleExemplarData? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONDecoder().decode(DoubleExemplarData.self, from: data)
    }
}

