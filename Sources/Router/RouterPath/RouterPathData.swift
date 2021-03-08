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
    public var userData: RouterPathUserData = RouterPathUserData()
    
    // Path Data is Optional
    public subscript(dynamicMember member: String) -> String? {
        return params[member]
    }
    
    internal init(params: [String: String] = [:]) {
        self.params = params
    }
}
