//
//  BackendLanguage.swift
//  AnkiBackend
//

public import Foundation

/// Maps the app's resolved UI language onto the language tags Anki's Rust
/// i18n understands, so backend-produced text (deck options, stats labels,
/// interval strings, errors) matches the language the UI is shown in.
public enum BackendLanguage {
    /// Anki ships Chinese as region-tagged `zh-CN` / `zh-TW` bundles, while
    /// iOS resolves Chinese localizations to script-tagged `zh-Hans` /
    /// `zh-Hant`. Other tags pass through unchanged — Anki's own fallback
    /// already reduces `de-AT` to `de` and so on.
    public static func ankiLangs(fromLocalizations localizations: [String]) -> [String] {
        let mapped = localizations.map { tag -> String in
            let lower = tag.lowercased()
            if lower.hasPrefix("zh-hans") || lower == "zh-cn" || lower == "zh-sg" { return "zh-CN" }
            if lower.hasPrefix("zh-hant") || lower == "zh-tw" || lower == "zh-hk" { return "zh-TW" }
            return tag
        }
        return mapped.isEmpty ? ["en"] : mapped
    }

    /// The language the app bundle actually resolved to for this launch.
    /// `preferredLocalizations` only lists localizations the app ships, so a
    /// device set to a language the UI isn't translated into stays English
    /// in the backend too instead of mixing two languages on one screen.
    public static var current: [String] {
        ankiLangs(fromLocalizations: Bundle.main.preferredLocalizations)
    }
}
