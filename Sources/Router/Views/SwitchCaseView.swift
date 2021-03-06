//
//  SwitchCaseView.swift
//  Router
//
//  Created by burt on 2021/03/06.
//

import SwiftUI

public class Switch<Value: Equatable> {
    private let value: Value?
    private var view: AnyView?
    public init(_ value: Value?) {
        self.value = value
    }
    
    public func Case<V: View>(_ v: Value?, @ViewBuilder content: @escaping (Value) -> V) -> Switch {
        guard view == nil else { return self }
        if v == value {
            self.view = AnyView(v.map(content))
        }
        return self
    }
    
    public func Else<V: View>(@ViewBuilder content: @escaping () -> V) -> AnyView {
        if let view = view {
            return view
        } else {
            return AnyView(content())
        }
    }
}
