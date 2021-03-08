//
//  SwitchCaseView.swift
//  Router
//
//  Created by burt on 2021/03/06.
//

import SwiftUI

public struct Switch<Value: Equatable>: View {
    private let value: Value?
    @State
    private var views: [(UUID, AnyView)] = []
    public init(_ value: Value?) {
        self.value = value
    }
    
    public var body: some View {
        ForEach(views, id: \.self.0) { v in
            v.1
        }
    }
    
    public func Case<V: View>(_ v: Value?, @ViewBuilder content: @escaping (Value) -> V) -> Switch {
        if v == value {
            views.append((UUID(), AnyView(v.map(content))))
        }
        return self
    }
}
