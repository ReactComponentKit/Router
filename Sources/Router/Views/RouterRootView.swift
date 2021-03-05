//
//  RouterRootView.swift
//  RouterExample
//
//  Created by burt on 2021/03/05.
//

import Foundation
import SwiftUI

public struct RouterRootView<Content: View>: View {
    private let name: String
    private let router: Router
    private let content: (Router) -> Content
    
    public var body: some View {
        RouterView(self.router) { router in
            content(router)
        }
        .onDisappear {
            // The .onAppear is called when view is added to view hierarchy, .onDisappear when removed.
            let router = Router.router(for: name)
            if router.navigationController.viewControllers.count <= 1 {
                Router.removeRoter(name: name)
            }
        }
        .environmentObject(Router.router(for: name))
        .edgesIgnoringSafeArea(.all)
    }
    
    public init(@ViewBuilder content: @escaping (Router) -> Content) {
        self.name = UUID().uuidString
        self.router = Router.router(for: name)
        self.content = content
    }
    
    public func path<V: View>(_ path: String, content: @escaping (RouterPathData) -> V) -> Self {
        Router.path(path, content: content)
        return self
    }
}

internal struct RouterView<Content: View>: UIViewControllerRepresentable {
    private weak var router: Router?
    private let content: (Router) -> Content
    
    internal init(_ router: Router, @ViewBuilder content: @escaping (Router) -> Content) {
        self.router = router
        self.content = content
    }
    
    internal func makeUIViewController(context: Context) -> UINavigationController {
        guard let router = router else { return UINavigationController() }
        router.navigationController.delegate = context.coordinator
        router.navigationController.navigationBar.prefersLargeTitles = true
        router.navigationController.navigationBar.backgroundColor = .clear
        let view = content(router)
        let viewController = UIHostingController(rootView: view)
        router.navigationController.setViewControllers([viewController], animated: false)
        return router.navigationController
    }
    
    internal func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
    
    internal func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

public class Coordinator: NSObject, UINavigationControllerDelegate {
}
