//
//  CardScanOperation.swift
//  Tangem
//
//  Created by Gennady Berezovsky on 17.10.18.
//  Copyright © 2018 Smart Cash AG. All rights reserved.
//

import Foundation
import CoreNFC

class CardScanner: NSObject {
    
    static let tangemWalletRecordType = "tangem.com:wallet"
    
    enum CardScannerResult {
        case success(Card)
        case readerSessionError(Error)
        case locked
        case tlvError
        case nonGenuineCard(Card)
    }
    
    var operationQueue = OperationQueue()
    var completion: (CardScannerResult) -> Void
    
    var session: NFCReaderSession?
    var savedChallenge: String?
    var savedSalt: String?
    
    init(completion: @escaping (CardScannerResult) -> Void) {
        self.completion = completion
    }
    
    func initiateScan(shouldCleanup: Bool = true) {
        if shouldCleanup {
            savedChallenge = nil
        }
        
        session = NFCNDEFReaderSession(delegate: self,
                                            queue: nil,
                                            invalidateAfterFirstRead: true)
        session?.begin()
    }
    
    func handleMessage(_ message: NFCNDEFMessage) {
        let payloads = message.records.filter { (record) -> Bool in
            guard let recordType = String(data: record.type, encoding: String.Encoding.utf8) else {
                return false
            }
            
            return recordType == CardScanner.tangemWalletRecordType
        }
        
        guard !payloads.isEmpty, let payload = payloads.first?.payload else {
            return
        }
        
        launchParsingOperationWith(payload: payload)
    }
    
    func launchParsingOperationWith(payload: Data) {
        operationQueue.cancelAllOperations()
        
        let operation = CardParsingOperation(payload: payload) { (result) in
            switch result {
            case .success(let card):
                self.handleDidParseCard(card)
                
            case .locked:
                self.completion(.locked)
            case .tlvError:
                self.completion(.tlvError)
            }
        }
        operationQueue.addOperation(operation)
    }
    
    func handleDidParseCard(_ card: Card) {
        
        guard let savedChallenge = savedChallenge, let savedSalt = savedSalt else {
            self.savedChallenge = card.challenge
            self.savedSalt = card.salt
            initiateScan(shouldCleanup: false)
            return
        }
        
        var card = card
        card.verificationChallenge = savedChallenge
        card.verificationSalt = savedSalt
        
        guard card.isAuthentic else {
            completion(.nonGenuineCard(card))
            return
        }
        
        completion(.success(card))
    }

}

extension CardScanner: NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        completion(.readerSessionError(error))
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        messages.forEach({ self.handleMessage($0) })
    }
    
}
