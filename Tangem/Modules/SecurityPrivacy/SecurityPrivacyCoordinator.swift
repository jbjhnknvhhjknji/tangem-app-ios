//
//  SecurityPrivacyCoordinator.swift
//  Tangem
//
//  Created by Sergey Balashov on 29.06.2022.
//  Copyright © 2022 Tangem AG. All rights reserved.
//

import Foundation

class SecurityPrivacyCoordinator: CoordinatorObject {
    var dismissAction: Action
    var popToRootAction: ParamsAction<PopToRootOptions>

    // MARK: - Main view model
    @Published private(set) var securityPrivacyViewModel: SecurityPrivacyViewModel?

    // MARK: - Child view models
    // TODO: Add other view models for different action

    // MARK: - Child coordinators
    @Published var securityManagementCoordinator: SecurityModeCoordinator?

    required init(dismissAction: @escaping Action, popToRootAction: @escaping ParamsAction<PopToRootOptions>) {
        self.dismissAction = dismissAction
        self.popToRootAction = popToRootAction
    }

    func start(with options: Options) {
        securityPrivacyViewModel = SecurityPrivacyViewModel(
            cardModel: options.cardModel,
            coordinator: self
        )
    }
}

extension SecurityPrivacyCoordinator {
    struct Options {
        let cardModel: CardViewModel
    }
}

// MARK: - SecurityPrivacyRoutable

extension SecurityPrivacyCoordinator: SecurityPrivacyRoutable {
    func openChangeAccessCode() {

    }

    func openSecurityMode(cardModel: CardViewModel) {
        let coordinator = SecurityModeCoordinator(popToRootAction: popToRootAction)
        let options = SecurityModeCoordinator.Options(cardModel: cardModel)
        coordinator.start(with: options)
        securityManagementCoordinator = coordinator
    }

    func openTokenSynchronization() {

    }

    func openResetSavedCards() {

    }
}
