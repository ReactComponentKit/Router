//
//  RouterPathData.swift
//  RouterExample
//
//  Created by burt on 2021/03/05.
//

import Foundation

@dynamicMemberLookup
public struct RouterPathData {
    private var params: [String: String]
    public var bindings: RouterPathBindingData = RouterPathBindingData()
    
    // Path Data is Optional
    public subscript<T>(dynamicMember member: String) -> T? {
        return params[member] as? T
    }
    
    internal init(params: [String: String] = [:]) {
        self.params = params
    }
}
