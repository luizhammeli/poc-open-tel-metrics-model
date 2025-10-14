//
//  Test_Open_TelApp.swift
//  Test-Open-Tel
//
//  Created by Luiz Diniz Hammerli on 14/10/25.
//

import SwiftUI
import OpenTelemetryApi
import OpenTelemetrySdk

@main
struct Test_Open_TelApp: App {
    init() {
        let exemplarData = DoubleExemplarDataDTO(value: 2, epochNanos: 12, filteredAttributes: ["test-2": .string("3")]).toExemplarData()
        let points = DoublePointDataDTO(value: 1, startEpochNanos: 2, endEpochNanos: 3, attributes: ["test-1": .string("2")], exemplars: [exemplarData!]).toDoublePointData()
        let value = MetricDataDTO(resource: Resource(), instrumentationScopeInfo: .init(), name: "test", description: "test-description", unit: "1", type: .DoubleGauge, isMonotonic: true, aggregationTemporality: .cumulative, dataPoints: [points!])
        let data = value.toMetricData()
        print("### \(data!)")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
