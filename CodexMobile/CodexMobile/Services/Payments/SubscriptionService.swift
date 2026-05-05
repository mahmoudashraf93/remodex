// FILE: SubscriptionService.swift
// Purpose: Owns local app-access state.
// Layer: Service
// Exports: SubscriptionService, SubscriptionBootstrapState
// Depends on: Foundation, Observation

import Foundation
import Observation

enum SubscriptionBootstrapState: Equatable {
    case idle
    case loading
    case ready
    case failed
}

@MainActor
@Observable
final class SubscriptionService {
    private static let freeSendLimit = 5

    private(set) var bootstrapState: SubscriptionBootstrapState = .ready
    private(set) var hasProAccess = true
    private(set) var freeSendCount = 0
    private(set) var latestPurchaseDate: Date?
    private(set) var willRenew = false
    private(set) var managementURL: URL?
    private(set) var isLoading = false
    private(set) var isPurchasing = false
    private(set) var isRestoring = false
    private(set) var lastErrorMessage: String?

    init(defaults: UserDefaults = .standard) {
        _ = defaults
        applyLocalUnlockState()
    }

    var remainingFreeSendAttempts: Int {
        Self.freeSendLimit
    }

    var hasFreeSendAccess: Bool {
        true
    }

    var hasAppAccess: Bool {
        true
    }

    func consumeFreeSendAttemptIfNeeded() {
        applyLocalUnlockState()
    }

    func bootstrap() async {
        applyLocalUnlockState()
    }

    func refreshCustomerInfoSilently() async {
        applyLocalUnlockState()
    }

    func loadOfferings() async {
        applyLocalUnlockState()
    }

    func restorePurchases() async {
        applyLocalUnlockState()
    }

    private func applyLocalUnlockState() {
        hasProAccess = true
        freeSendCount = 0
        bootstrapState = .ready
        isLoading = false
        isPurchasing = false
        isRestoring = false
        lastErrorMessage = nil
    }
}
