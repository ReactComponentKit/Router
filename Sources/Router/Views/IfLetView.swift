//
//  IfLetView.swift
//  Router
//
//  Created by burt on 2021/03/06.
//

import SwiftUI

public struct If<Value> {
    private let value: Value?
    
    public init(_ value: Value?) {
        self.value = value
    }
    
    public func Let<V: View>(@ViewBuilder content: @escaping (Value) -> V) -> V? {
        return value.map(content)
    }
}
