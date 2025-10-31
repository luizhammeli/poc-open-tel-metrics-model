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


//import UIKit
//
//func deviceIdentifier() -> String {
//    var systemInfo = utsname()
//    uname(&systemInfo)
//    return String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?
//        .trimmingCharacters(in: .controlCharacters) ?? "Unknown"
//}
//
//print(deviceIdentifier())



// func deviceModelName() -> String {
//     var systemInfo = utsname()
//     uname(&systemInfo)
//     let identifier = String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)),
//                             encoding: .ascii)?
//         .trimmingCharacters(in: .controlCharacters) ?? "Unknown"

//     // ✅ Detecta se está no simulador
//     if identifier == "x86_64" || identifier == "arm64" {
//         if let simIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
//             return "Simulator (\(mapModel(simIdentifier)))"
//         }
//         return "Simulator (Unknown)"
//     }

//     return mapModel(identifier)
// }


//     switch identifier {
//     // MARK: - iPhone 4 → 5s
//     case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
//     case "iPhone4,1": return "iPhone 4s"
//     case "iPhone5,1", "iPhone5,2": return "iPhone 5"
//     case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
//     case "iPhone6,1", "iPhone6,2": return "iPhone 5s"

//     // MARK: - iPhone 6 → SE (1st gen)
//     case "iPhone7,2": return "iPhone 6"
//     case "iPhone7,1": return "iPhone 6 Plus"
//     case "iPhone8,1": return "iPhone 6s"
//     case "iPhone8,2": return "iPhone 6s Plus"
//     case "iPhone8,4": return "iPhone SE (1st generation)"

//     // MARK: - iPhone 7 → X
//     case "iPhone9,1", "iPhone9,3": return "iPhone 7"
//     case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
//     case "iPhone10,1", "iPhone10,4": return "iPhone 8"
//     case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
//     case "iPhone10,3", "iPhone10,6": return "iPhone X"

//     // MARK: - iPhone XR → 11 Pro Max
//     case "iPhone11,8": return "iPhone XR"
//     case "iPhone11,2": return "iPhone XS"
//     case "iPhone11,6", "iPhone11,4": return "iPhone XS Max"
//     case "iPhone12,1": return "iPhone 11"
//     case "iPhone12,3": return "iPhone 11 Pro"
//     case "iPhone12,5": return "iPhone 11 Pro Max"

//     // MARK: - iPhone SE (2nd) → 14
//     case "iPhone12,8": return "iPhone SE (2nd generation)"
//     case "iPhone13,1": return "iPhone 12 mini"
//     case "iPhone13,2": return "iPhone 12"
//     case "iPhone13,3": return "iPhone 12 Pro"
//     case "iPhone13,4": return "iPhone 12 Pro Max"
//     case "iPhone14,4": return "iPhone 13 mini"
//     case "iPhone14,5": return "iPhone 13"
//     case "iPhone14,2": return "iPhone 13 Pro"
//     case "iPhone14,3": return "iPhone 13 Pro Max"
//     case "iPhone14,6": return "iPhone SE (3rd generation)"
//     case "iPhone15,2": return "iPhone 14 Pro"
//     case "iPhone15,3": return "iPhone 14 Pro Max"
//     case "iPhone14,7": return "iPhone 14"
//     case "iPhone14,8": return "iPhone 14 Plus"

//     // MARK: - iPhone 15 series
//     case "iPhone15,4": return "iPhone 15"
//     case "iPhone15,5": return "iPhone 15 Plus"
//     case "iPhone16,1": return "iPhone 15 Pro"
//     case "iPhone16,2": return "iPhone 15 Pro Max"

//     // MARK: - Simulator
//     case "i386", "x86_64", "arm64":
//         return "Simulator (\(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Unknown"))"

//     default:
//         return identifier // fallback
//     }
// }

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

