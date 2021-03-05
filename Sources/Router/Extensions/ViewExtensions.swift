//
//  ViewExtensions.swift
//  RouterExample
//
//  Created by burt on 2021/03/01.
//

import Foundation
import SwiftUI

extension View {
    internal func toViewController() -> UIViewController {
        return UIHostingController(rootView: self)
    }
    
    internal func toAnyView() -> AnyView {
        return AnyView(self)
    }
    
    public func asRouterRootView() -> some View {
        return RouterRootView { router in
            self.environmentObject(router)
        }
    }
}
