//
//  RouterPresentationMode.swift
//  RouterExample
//
//  Created by burt on 2021/03/01.
//

import Foundation
import SwiftUI

public enum RouterPresentationMode {
    case none
    case push
    case sheet
    case fullscreen
    case overFullscreen
    case replace
    case formSheet
    case currentContext
    case overCurrentContext
    // TODO suport popover delegate injection
    // case popover
}

public class RouterPresentationModeValue {
    public var wrappedValue: UIViewController?
    internal var mode: RouterPresentationMode    
    public var isPresented: Bool {
        switch mode {
        case .sheet, .fullscreen, .overFullscreen, .formSheet, .currentContext, .overCurrentContext:
            return wrappedValue?.presentingViewController != nil
        case .push:
            return wrappedValue?.navigationController?.viewControllers.last == wrappedValue
        case .replace:
            return true
        default:
            return false
        }
    }

    internal init(mode: RouterPresentationMode = .none) {
        self.mode = mode
    }
    
    public func dismiss(animated: Bool = true, completion: @escaping () -> Void = { }) {
        switch mode {
        case .sheet, .fullscreen, .overFullscreen, .formSheet, .currentContext, .overCurrentContext:
            wrappedValue?.dismiss(animated: animated, completion: completion)
        case .push:
            wrappedValue?.navigationController?.popViewController(animated: animated)
            completion()
        case .replace:
            // ignore
            break
        case .none:
            // ignore
            break
        }
    }
}

public struct RouterPresentationModeKey: EnvironmentKey {
    public static var defaultValue: RouterPresentationModeValue = RouterPresentationModeValue()
}

extension EnvironmentValues {
    // support @Environment(\.routerPresentationMode) var presentationMode
    public var routerPresentationMode: RouterPresentationModeValue {
        get { self[RouterPresentationModeKey.self] }
        set { self[RouterPresentationModeKey.self] = newValue }
    }
}
