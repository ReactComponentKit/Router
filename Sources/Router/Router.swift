//
//  Router.swift
//  Router
//
//  Created by sungcheol.kim on 2021/02/16.
//

import SwiftUI

public class Router: ObservableObject {
    private static var routerMap: [String: Router] = [:]
    private let name: String
    
    // You cann access navigationController If you need to it
    public var navigationController = UINavigationController()
    
    // Define Router path and map it to the SwiftUI View
    public static func path<V: View>(_ path: String, @ViewBuilder content: @escaping (RouterPathData) -> V) {
        guard
            let url = URL(string: path),
            let scheme = url.scheme,
            let host = url.host
        else {
            return
        }
        
        let routerPath = RouterPath(path: "\(scheme)://\(host)", view: { routerPathData in
            content(routerPathData).toAnyView()
        })

        RouterPathManager.shared.set(routerPath: routerPath, forPath: "\(scheme)://\(host)")
    }
    
    internal static func router(for name: String) -> Router {
        if let router = routerMap[name] {
            return router
        } else {
            let router = Router(name: name)
            routerMap[name] = router
            return router
        }
    }
    
    internal static func removeRoter(name: String) {
        routerMap.removeValue(forKey: name)
    }
    
    internal init(name: String) {
        self.name = name
    }
    
    private func makeViewController<V: View>(view: V, mode: RouterPresentationMode) -> UIViewController {
        let presentationModeValue = RouterPresentationModeValue(mode: mode)
        let v = view
            .environmentObject(Router.router(for: self.name))
            .environment(\.routerPresentationMode, presentationModeValue)
        let vc = v.toViewController()
        presentationModeValue.wrappedValue = vc
        return vc
    }
    
    // navigation actions
    public func push<V: View>(_ view: V, animated: Bool = true) {
        let vc = makeViewController(view: view, mode: .push)
        self.navigationController.pushViewController(vc, animated: animated)
    }

    public func push<V: View>(animated: Bool = true, @ViewBuilder content: @escaping () -> V) {
        let vc = makeViewController(view: content(), mode: .push)
        self.navigationController.pushViewController(vc, animated: animated)
    }
    
    public func popToRoot(animated: Bool = true) {
        self.navigationController.popToRootViewController(animated: animated)
    }
    
    public func pop(animated: Bool = true) {
        self.navigationController.popViewController(animated: animated)
    }
    
    public func replace<V: View>(_ view: V, animted: Bool = false) {
        let vc = makeViewController(view: view, mode: .replace)
        self.navigationController.setViewControllers([vc], animated: animted)
    }

    public func replace<V: View>(animted: Bool = false, @ViewBuilder content: @escaping () -> V) {
        let vc = makeViewController(view: content(), mode: .replace)
        self.navigationController.setViewControllers([vc], animated: animted)
    }
    
    public func sheet<V: View>(_ view: V, animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical) {
        let vc = makeViewController(view: view, mode: .sheet)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
    public func sheet<V: View>(animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical, @ViewBuilder content: @escaping () -> V) {
        let vc = makeViewController(view: content(), mode: .sheet)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
    public func fullscreen<V: View>(_ view: V, animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical) {
        let vc = makeViewController(view: view, mode: .fullscreen)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
    public func fullscreen<V: View>(animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical, @ViewBuilder content: @escaping () -> V) {
        let vc = makeViewController(view: content(), mode: .fullscreen)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
    public func overFullscreen<V: View>(_ view: V, animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical) {
        let vc = makeViewController(view: view, mode: .overFullscreen)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
    public func overFullscreen<V: View>(animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical, @ViewBuilder content: @escaping () -> V) {
        let vc = makeViewController(view: content(), mode: .overFullscreen)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
    public func formSheet<V: View>(_ view: V, animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical) {
        let vc = makeViewController(view: view, mode: .formSheet)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
    public func formSheet<V: View>(animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical, @ViewBuilder content: @escaping () -> V) {
        let vc = makeViewController(view: content(), mode: .formSheet)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
    public func currentContext<V: View>(_ view: V, animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical) {
        let vc = makeViewController(view: view, mode: .currentContext)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.currentContext
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
    public func currentContext<V: View>(animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical, @ViewBuilder content: @escaping () -> V) {
        let vc = makeViewController(view: content(), mode: .currentContext)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.currentContext
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
    public func overCurrentContext<V: View>(_ view: V, animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical) {
        let vc = makeViewController(view: view, mode: .overCurrentContext)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
    public func overCurrentContext<V: View>(animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical, @ViewBuilder content: @escaping () -> V) {
        let vc = makeViewController(view: content(), mode: .overCurrentContext)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController.present(vc, animated: animated, completion: nil)
    }
    
//    public func popover<V: View>(_ view: V, animated: Bool = true) {
//        let vc = makeViewController(view: view, mode: .popover)
//        vc.modalPresentationStyle = UIModalPresentationStyle.popover
//        self.navigationController.present(vc, animated: animated, completion: nil)
//    }
//
//    public func popover<V: View>(animated: Bool = true, @ViewBuilder content: @escaping () -> V) {
//        let vc = makeViewController(view: content(), mode: .popover)
//        vc.modalPresentationStyle = UIModalPresentationStyle.popover
//        self.navigationController.present(vc, animated: animated, completion: nil)
//    }
    
    // route to the view with some data(optional)
    public func route(_ path: String, _ mode: RouterPresentationMode, animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical) {
        guard let routerPath = RouterPathManager.shared.routerPath(forPath: path) else { return }
        
        // parsing path's query into router path data
        var params: [String: String] = [:]
        if let queryItems = URLComponents(string: path)?.queryItems {
            var result: [String: String] = [:]
            queryItems.forEach {
                if let value = $0.value {
                    result[$0.name] = value
                }
            }
            params = result
        }
        
        let view = routerPath.view(RouterPathData(params: params))
        switch mode {
        case .push:
            push(view, animated: animated)
        case .sheet:
            sheet(view, animated: animated, transitionStyle: transitionStyle)
        case .fullscreen:
            fullscreen(view, animated: animated, transitionStyle: transitionStyle)
        case .overFullscreen:
            overFullscreen(view, animated: animated, transitionStyle: transitionStyle)
        case .replace:
            replace(view, animted: animated)
        case .formSheet:
            formSheet(view, animated: animated, transitionStyle: transitionStyle)
        case .currentContext:
            currentContext(view, animated: animated, transitionStyle: transitionStyle)
        case .overCurrentContext:
            overCurrentContext(view, animated: animated, transitionStyle: transitionStyle)
//        case .popover:
//            popover(view, animated: animated)
        case .none:
            break
        }
    }
    
    // private route method for supporting binding data and injection environment varianbles and environment objects
    // You should use builder method to passing binding data and environment things
    private func route_with_injection<V: View>(_ path: String, _ mode: RouterPresentationMode, animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical, bindings: RouterPathBindingData, injection: (AnyView) -> V) {
        guard let routerPath = RouterPathManager.shared.routerPath(forPath: path) else { return }
        var params: [String: String] = [:]
        if let queryItems = URLComponents(string: path)?.queryItems {
            var result: [String: String] = [:]
            queryItems.forEach {
                if let value = $0.value {
                    result[$0.name] = value
                }
            }
            params = result
        }
        
        // path의 쿼리를 파싱하여 인자를 인젝션해 주어야 한다.
        var data = RouterPathData(params: params)
        data.bindings = bindings
        let view = routerPath.view(data)
        let finalView = injection(view)
        switch mode {
        case .push:
            push(finalView, animated: animated)
        case .sheet:
            sheet(finalView, animated: animated, transitionStyle: transitionStyle)
        case .fullscreen:
            fullscreen(finalView, animated: animated, transitionStyle: transitionStyle)
        case .overFullscreen:
            overFullscreen(finalView, animated: animated, transitionStyle: transitionStyle)
        case .replace:
            replace(finalView, animted: animated)
        case .formSheet:
            formSheet(finalView, animated: animated, transitionStyle: transitionStyle)
        case .currentContext:
            currentContext(finalView, animated: animated, transitionStyle: transitionStyle)
        case .overCurrentContext:
            overCurrentContext(finalView, animated: animated, transitionStyle: transitionStyle)
//        case .popover:
//            popover(finalView, animated: animated)
        case .none:
            break
        }
    }
    
    private func route_without_injection(_ path: String, _ mode: RouterPresentationMode, animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical, bindings: RouterPathBindingData) {
        guard let routerPath = RouterPathManager.shared.routerPath(forPath: path) else { return }
        var params: [String: String] = [:]
        if let queryItems = URLComponents(string: path)?.queryItems {
            var result: [String: String] = [:]
            queryItems.forEach {
                if let value = $0.value {
                    result[$0.name] = value
                }
            }
            params = result
        }
        
        // path의 쿼리를 파싱하여 인자를 인젝션해 주어야 한다.
        var data = RouterPathData(params: params)
        data.bindings = bindings
        let finalView = routerPath.view(data)
        switch mode {
        case .push:
            push(finalView, animated: animated)
        case .sheet:
            sheet(finalView, animated: animated, transitionStyle: transitionStyle)
        case .fullscreen:
            fullscreen(finalView, animated: animated, transitionStyle: transitionStyle)
        case .overFullscreen:
            overFullscreen(finalView, animated: animated, transitionStyle: transitionStyle)
        case .replace:
            replace(finalView, animted: animated)
        case .formSheet:
            formSheet(finalView, animated: animated, transitionStyle: transitionStyle)
        case .currentContext:
            currentContext(finalView, animated: animated, transitionStyle: transitionStyle)
        case .overCurrentContext:
            overCurrentContext(finalView, animated: animated, transitionStyle: transitionStyle)
//        case .popover:
//            popover(finalView, animated: animated)
        case .none:
            break
        }
    }
    
    // generate RouterBuilder
    // ex)
    // router.builder()
    //  .route("route://detail?a=123&b=Hello")
    //  .presentation(mode: .sheet)
    //  .binding(name: "test", $test)
    //  .go {
    //      $0.environment(\.colorScheme, .light)
    //  }
    public func builder() -> RouteBuilder {
        return RouteBuilder(router: self)
    }
    
    public class RouteBuilder {
        private weak var router: Router?
        private var path: String = ""
        private var mode: RouterPresentationMode = .none
        private var animated: Bool = true
        private var transitionStyle: UIModalTransitionStyle = .coverVertical
        private var bindings: [String: Any] = [:]

        internal init(router: Router) {
            self.router = router
        }
        
        public func route(_ path: String) -> Self {
            self.path = path
            return self
        }
        
        public func presentation(mode: RouterPresentationMode) -> Self {
            self.mode = mode
            return self
        }
        
        public func animated(_ animated: Bool) -> Self {
            self.animated = animated
            return self
        }
        
        public func transition(style: UIModalTransitionStyle) -> Self {
            self.transitionStyle = style
            return self
        }
        
        public func binding<T>(name: String,  to value: Binding<T>) -> Self {
            bindings[name] = value
            return self
        }
        
        public func go() {
            router?.route_without_injection(self.path, self.mode, animated: self.animated, bindings: RouterPathBindingData(bindings: self.bindings))
        }
        
        public func go<V: View>(with injection: (AnyView) -> V = { $0 as! V  }) {
            router?.route_with_injection(self.path, self.mode, animated: self.animated, bindings: RouterPathBindingData(bindings: self.bindings), injection: injection)
        }
    }
}
