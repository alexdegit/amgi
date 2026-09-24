//
//  ChartAccessibility.swift
//  StatsCharts
//

import Foundation

enum ChartSpeech {
    static func day(_ offset: Int) -> String {
        switch offset {
        case 0: String(localized: "Today")
        case 1: String(localized: "Tomorrow")
        case -1: String(localized: "Yesterday")
        case ..<0: String(localized: "\(-offset) days ago")
        default: String(localized: "In \(offset) days")
        }
    }

    /// What a chart mark counts. A closed set rather than a free-form noun,
    /// so every phrase is a whole sentence the translator can see.
    enum Noun {
        case card, review, press, day
    }

    static func count(_ value: Int, _ noun: Noun) -> String {
        switch (noun, value == 1) {
        case (.card, true): String(localized: "1 card")
        case (.card, false): String(localized: "\(value) cards")
        case (.review, true): String(localized: "1 review")
        case (.review, false): String(localized: "\(value) reviews")
        case (.press, true): String(localized: "1 press")
        case (.press, false): String(localized: "\(value) presses")
        case (.day, true): String(localized: "1 day")
        case (.day, false): String(localized: "\(value) days")
        }
    }

    static func percent(_ value: Double) -> String {
        "\(Int(value.rounded()))%"
    }
}
