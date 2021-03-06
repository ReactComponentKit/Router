//
//  SwitchBindingCaseView.swift
//  Router
//
//  Created by burt on 2021/03/08.
//

import Foundation
import SwiftUI

internal class ViewContainer<Value: Equatable> {
    internal var views: [(UUID, (Value) -> AnyView)] = []
    internal init() {
        self.views = []
    }
    internal func append<V: View>(caseValue: Value, builder:  @escaping (Value) -> V) {
        self.views.append((UUID(), { newValue in
            caseValue == newValue ? AnyView(builder(caseValue)) : AnyView(EmptyView())
        }))
    }
}

public struct SwitchBinding<Value: Equatable>: View {
    private var container = ViewContainer<Value>()
    public var value: Binding<Value>
    public var body: some View {
        ForEach(container.views, id: \.self.0) { v in
            v.1(value.wrappedValue)
        }
    }
    
    public func Case<V: View>(_ v: Value?, @ViewBuilder content: @escaping (Value) -> V) -> SwitchBinding {
        guard let v = v else { return self }
        container.append(caseValue: v, builder: content)
        return self
    }
    
    public init(_ value: Binding<Value>) {
        self.value = value
    }
}
