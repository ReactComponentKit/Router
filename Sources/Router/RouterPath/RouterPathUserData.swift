//
//  RouterPathUserData.swift
//  Router
//
//  Created by burt on 2021/03/08.
//

import Foundation

@dynamicMemberLookup
public struct RouterPathUserData {
    private var userData: [String: Any]
    
    // User Data must be placed.
    public subscript<T>(dynamicMember member: String) -> T {
        return userData[member] as! T
    }
    
    internal init(userData: [String: Any] = [:]) {
        self.userData = userData
    }
}

