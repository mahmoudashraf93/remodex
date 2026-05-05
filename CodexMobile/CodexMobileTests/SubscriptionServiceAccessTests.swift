// FILE: SubscriptionServiceAccessTests.swift
// Purpose: Verifies local app access remains unlocked without consuming free-send attempts.
// Layer: Unit Test
// Exports: SubscriptionServiceAccessTests
// Depends on: XCTest, CodexMobile

import XCTest
@testable import CodexMobile

@MainActor
final class SubscriptionServiceAccessTests: XCTestCase {
    func testFreshUserStartsWithUnlockedAccess() {
        let service = makeService()

        XCTAssertEqual(service.freeSendCount, 0)
        XCTAssertEqual(service.remainingFreeSendAttempts, 5)
        XCTAssertTrue(service.hasFreeSendAccess)
        XCTAssertTrue(service.hasAppAccess)
        XCTAssertTrue(service.hasProAccess)
    }

    func testSendAttemptsAreNotConsumedWhenAccessIsUnlocked() {
        let service = makeService()

        for _ in 0..<7 {
            service.consumeFreeSendAttemptIfNeeded()
        }

        XCTAssertEqual(service.freeSendCount, 0)
        XCTAssertEqual(service.remainingFreeSendAttempts, 5)
        XCTAssertTrue(service.hasFreeSendAccess)
        XCTAssertTrue(service.hasAppAccess)
        XCTAssertTrue(service.hasProAccess)
    }

    func testBootstrapKeepsAccessUnlocked() async {
        let service = makeService()

        await service.bootstrap()

        XCTAssertEqual(service.bootstrapState, .ready)
        XCTAssertTrue(service.hasAppAccess)
        XCTAssertTrue(service.hasFreeSendAccess)
        XCTAssertTrue(service.hasProAccess)
    }

    private func makeService() -> SubscriptionService {
        let suiteName = "SubscriptionServiceAccessTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        defaults.removePersistentDomain(forName: suiteName)
        return SubscriptionService(defaults: defaults)
    }
}
