//
//  PeriodPicker.swift
//  StatsCharts
//
//  Created by Vladimir Gusev on 30.03.2026.
//

import SwiftUI

public enum StatsPeriod: String, CaseIterable, Sendable {
    case day = "Today"
    case week = "7 Days"
    case month = "1 Month"
    case threeMonths = "3 Months"
    case year = "1 Year"
    case all = "All Time"

    public var days: Int {
        switch self {
        case .day: 1
        case .week: 7
        case .month: 31
        case .threeMonths: 92
        case .year: 365
        case .all: 36500
        }
    }

    /// User-facing name. `rawValue` stays English because it is the enum's
    /// identity; display always goes through here.
    public var displayName: String {
        switch self {
        case .day: String(localized: "Today")
        case .week: String(localized: "7 Days")
        case .month: String(localized: "1 Month")
        case .threeMonths: String(localized: "3 Months")
        case .year: String(localized: "1 Year")
        case .all: String(localized: "All Time")
        }
    }

    public var shortLabel: String {
        switch self {
        case .day: String(localized: "1D")
        case .week: String(localized: "7D")
        case .month: String(localized: "1M")
        case .threeMonths: String(localized: "3M")
        case .year: String(localized: "1Y")
        case .all: String(localized: "All")
        }
    }
}
