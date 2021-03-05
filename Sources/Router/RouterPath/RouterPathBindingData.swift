//
//  RouterPathBindingData.swift
//  RouterExample
//
//  Created by burt on 2021/03/05.
//

import Foundation

@dynamicMemberLookup
public struct RouterPathBindingData {
    private var bindings: [String: Any]
    
    // Binding Data must be placed.
    public subscript<T>(dynamicMember member: String) -> T {
        return bindings[member] as! T
    }
    
    internal init(bindings: [String: Any] = [:]) {
        self.bindings = bindings
    }
}
