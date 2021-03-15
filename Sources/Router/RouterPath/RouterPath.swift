//
//  RouterPath.swift
//  RouterExample
//
//  Created by burt on 2021/03/05.
//

import Foundation
import SwiftUI

internal struct RouterPath {
    let path: String
    let view: (RouterPathData) -> AnyView
}

internal class RouterPathManager {
    static let shared = RouterPathManager()
    
    private var routerPathMap = [String:RouterPath]()
    
    private init() {
    }
    
    internal func set(routerPath: RouterPath, forPath path: String) {
        routerPathMap[path] = routerPath
    }
    
    internal func routerPath(forPath path: String) -> RouterPath? {
        guard
            let url = URL(string: path),
            let scheme = url.scheme,
            let host = url.host
        else {
            return nil
        }
        return routerPathMap["\(scheme)://\(host + url.path)"]
    }
}
