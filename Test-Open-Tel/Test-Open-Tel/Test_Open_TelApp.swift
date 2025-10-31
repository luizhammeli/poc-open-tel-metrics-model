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



private struct AssociatedKeys {
    static var loadStartTimeKey: UInt8 = 0
}

extension UIViewController {
    var loadStartTime: CFAbsoluteTime? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.loadStartTimeKey) as? CFAbsoluteTime }
        set { objc_setAssociatedObject(self, &AssociatedKeys.loadStartTimeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc func swizzled_viewDidLoad() {
        self.loadStartTime = CFAbsoluteTimeGetCurrent()
        self.swizzled_viewDidLoad() // chama o original
    }

    @objc func swizzled_viewDidAppear(_ animated: Bool) {
        self.swizzled_viewDidAppear(animated)
        if let start = loadStartTime {
            let duration = CFAbsoluteTimeGetCurrent() - start
            print("⏱️ \(type(of: self)) levou \(duration)s para aparecer")
        }
    }

    static func swizzleLoadTracking() {
        let pairs: [(Selector, Selector)] = [
            (#selector(viewDidLoad), #selector(swizzled_viewDidLoad)),
            (#selector(viewDidAppear(_:)), #selector(swizzled_viewDidAppear(_:)))
        ]
        for (original, swizzled) in pairs {
            guard
                let originalMethod = class_getInstanceMethod(self, original),
                let swizzledMethod = class_getInstanceMethod(self, swizzled)
            else { continue }
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

