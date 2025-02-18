//
//  TransactionHistoryMapper.swift
//  Tangem
//
//  Created by Andrew Son on 10/02/23.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import BlockchainSdk

struct TransactionHistoryMapper {
    private let currencySymbol: String
    private let walletAddress: String

    private let balanceFormatter = BalanceFormatter()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    init(currencySymbol: String, walletAddress: String) {
        self.currencySymbol = currencySymbol
        self.walletAddress = walletAddress
    }

    func mapTransactionListItem(from records: [TransactionRecord]) -> [TransactionListItem] {
        let grouped = Dictionary(grouping: records, by: { Calendar.current.startOfDay(for: $0.date ?? Date()) })

        return grouped.sorted(by: { $0.key > $1.key }).reduce([]) { result, args in
            let (key, value) = args
            let item = TransactionListItem(
                header: dateFormatter.string(from: key),
                items: value.map(mapTransactionViewModel)
            )

            return result + [item]
        }
    }

    func mapTransactionViewModel(_ record: TransactionRecord) -> TransactionViewModel {
        var timeFormatted: String?
        if let date = record.date {
            timeFormatted = timeFormatter.string(from: date)
        }

        return TransactionViewModel(
            id: record.hash,
            interactionAddress: interactionAddress(from: record),
            timeFormatted: timeFormatted,
            amount: transferAmount(from: record),
            isOutgoing: record.type == .send,
            transactionType: transactionType(from: record),
            status: record.status == .confirmed ? .confirmed : .inProgress
        )
    }
}

// MARK: - TransactionHistoryMapper

private extension TransactionHistoryMapper {
    func transferAmount(from record: TransactionRecord) -> String {
        switch record.type {
        case .send:
            let sent: Decimal = {
                switch record.source {
                case .single(let source):
                    return source.amount
                case .multiple(let sources):
                    return sources.sum(for: walletAddress)
                }
            }()

            let change: Decimal = {
                switch record.destination {
                case .single(let destination):
                    return destination.address.string == walletAddress ? destination.amount : 0
                case .multiple(let destinations):
                    return destinations.sum(for: walletAddress)
                }
            }()

            let amount = sent - change
            return balanceFormatter.formatCryptoBalance(amount, currencyCode: currencySymbol)

        case .receive:
            let received: Decimal = {
                switch record.destination {
                case .single(let destination):
                    return destination.amount
                case .multiple(let destinations):
                    return destinations.sum(for: walletAddress)
                }
            }()

            return balanceFormatter.formatCryptoBalance(received, currencyCode: currencySymbol)
        }
    }

    func interactionAddress(from record: TransactionRecord) -> TransactionViewModel.InteractionAddressType {
        switch record.type {
        case .send:
            return mapToInteractionAddressType(destination: record.destination)
        case .receive:
            return mapToInteractionAddressType(source: record.source)
        }
    }

    func mapToInteractionAddressType(source: TransactionRecord.SourceType) -> TransactionViewModel.InteractionAddressType {
        switch source {
        case .single(let source):
            return .user(source.address)
        case .multiple(let sources):
            return .multiple(sources.map { $0.address })
        }
    }

    func mapToInteractionAddressType(destination: TransactionRecord.DestinationType) -> TransactionViewModel.InteractionAddressType {
        switch destination {
        case .single(let destination):
            switch destination.address {
            case .user(let address):
                return .user(address)
            case .contract(let address):
                return .contract(address)
            }
        case .multiple(let destinations):
            return .multiple(destinations.map { $0.address.string })
        }
    }

    func transactionType(from record: TransactionRecord) -> TransactionViewModel.TransactionType {
        switch record.type {
        case .receive:
            return .transfer
        case .send:
            return .transfer
        }
    }
}

extension TransactionHistoryMapper {
    enum Constants {
        static let maximumFractionDigits = 8
        static let roundingMode: NSDecimalNumber.RoundingMode = .down
    }
}

private extension Array where Element == TransactionRecord.Destination {
    func sum(for address: String) -> Decimal {
        filter { $0.address.string == address }.reduce(0) { $0 + $1.amount }
    }
}

private extension Array where Element == TransactionRecord.Source {
    func sum(for address: String) -> Decimal {
        filter { $0.address == address }.reduce(0) { $0 + $1.amount }
    }
}
