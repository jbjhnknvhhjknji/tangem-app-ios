//
//  WarningsContainer.swift
//  Tangem Tap
//
//  Created by Andrew Son on 27/12/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import Combine

class WarningsContainer: ObservableObject {
    var criticals: [TapWarning]
    var warnings: [TapWarning]
    var infos: [TapWarning]
    
    init(criticals: [TapWarning] = [], warnings: [TapWarning] = [], infos: [TapWarning] = []) {
        self.criticals = criticals
        self.warnings = warnings
        self.infos = infos
    }
    
    func add(_ warning: TapWarning) {
        switch warning.priority {
        case .critical:
            if criticals.contains(warning) { return }
            
            criticals.append(warning)
            
        case .warning:
            if warnings.contains(warning) { return }
            
            warnings.append(warning)
            
        case .info: 
            if infos.contains(warning) { return }
            
            infos.append(warning)
        }
    }
    
    func add(_ warnings: [TapWarning]) {
        warnings.forEach { add($0) }
    }
    
    func addWarning(for event: WarningEvent) {
        add(event.warning)
    }
    
    func remove(_ warning: TapWarning) {
        switch warning.priority {
        case .critical:
            criticals.removeAll(where: { $0 == warning })
        case .warning:
            warnings.removeAll(where: { $0 == warning })
        case .info:
            infos.removeAll(where: { $0 == warning })
        }
    }
}
