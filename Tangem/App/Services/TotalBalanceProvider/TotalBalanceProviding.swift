//
//  TotalBalanceProviding.swift
//  Tangem
//
//  Created by Sergey Balashov on 16.09.2022.
//  Copyright © 2022 Tangem AG. All rights reserved.
//

import Combine

protocol TotalBalanceProviding {
    func subscribeToTotalBalance() -> AnyPublisher<ValueState<TotalBalanceProvider.TotalBalance>, Never>
    func updateTotalBalance()
}
