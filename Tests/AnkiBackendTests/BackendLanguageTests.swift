//
//  BackendLanguageTests.swift
//  AnkiBackendTests
//

import Testing
@testable import AnkiBackend

@Suite struct BackendLanguageTests {
    @Test func simplifiedChineseMapsToAnkiZhCN() {
        #expect(BackendLanguage.ankiLangs(fromLocalizations: ["zh-Hans"]) == ["zh-CN"])
    }

    @Test func regionTaggedSimplifiedChineseMapsToAnkiZhCN() {
        #expect(BackendLanguage.ankiLangs(fromLocalizations: ["zh-Hans-CN"]) == ["zh-CN"])
    }

    @Test func traditionalChineseMapsToAnkiZhTW() {
        #expect(BackendLanguage.ankiLangs(fromLocalizations: ["zh-Hant"]) == ["zh-TW"])
    }

    @Test func englishPassesThrough() {
        #expect(BackendLanguage.ankiLangs(fromLocalizations: ["en"]) == ["en"])
    }

    @Test func orderIsPreservedForFallback() {
        #expect(BackendLanguage.ankiLangs(fromLocalizations: ["zh-Hans", "en"]) == ["zh-CN", "en"])
    }

    @Test func emptyListFallsBackToEnglish() {
        #expect(BackendLanguage.ankiLangs(fromLocalizations: []) == ["en"])
    }
}
