# Router

Router for SwiftUI 🚀 Router uses UINavigationController behind scene so Router can be used only for iOS.😄

## Example([Go to Code](https://github.com/ReactComponentKit/RouterExample))

<center><img src='https://github.com/ReactComponentKit/RouterExample/blob/main/example.gif?raw=true'></center>

## RouterRootView

You can define Router start position by using RouterRootView. If you call popToRoot(), you can back to the start position.

```swift
var body: some Scene {
    WindowGroup {
        RouterRootView { router in
            ContentView()        
        }
    }
}
```

RouterRootView inject the router into the ViewBuilder.  you can route to any view with router.

```swift
var body: some Scene {
    WindowGroup {
        RouterRootView { router in
            Button("Go to SomeView") {
                router.route("myscheme://someview", .push)
            }
        }
    }
}
```

## Define router path and map it to the View

```swift
var body: some Scene {
    WindowGroup {
        RouterRootView { router in
            Button("Go to SomeView") {
                router.route("myscheme://someview?i=10&s=hello", .push)
            }
        }
        .path("myscheme://someview") { data in
            SomeView(number: data.i.flatMap { Int($0) } ?? 0, message: data.s ?? "")
        }
        .path("myscheme://detail") { _ in 
            DetailView()
        }
    }
}
```

## Route to the View

There are two ways for routing to the view. 

### Routing with path

```swift
Button("Route to the View") {
    router.route("myscheme://detail", .sheet)
}
```

### Routing with navigation methods

```swift
Button("Route to the View") {
    router.sheet(DetailView())
}
```

## Pass bindings and Inject Environment things

If you want to pass binding or environment things, you should use builder method.

```swift
Button("router with binding") {
    router.builder()
        .route("route://detail?a=123&b=Hello")
        .presentation(mode: .sheet)
        .binding(name: "test", $test)
        .go {
            $0.environment(\.colorScheme, .light)
        }
}
```

You can register path like below:

```swift
var body: some Scene {
    WindowGroup {
        RouterRootView { router in
            Button("Go to SomeView") {
                router.route("myscheme://someview?i=10&s=hello", .push)
            }
        }
        .path("myscheme://detail") { data in 
            DetailView(a: data.a.flatMap { Int($0) } ?? 0, b: data.b ?? "", test: data.bindings.test)
        }
    }
}
```

## Navigation Methods

- push()
- sheet()
- fullscreen()
- overFullscreen()
- replace()
- popToRoot()


## Presentation Mode with Route.route

- .push
- .sheet
- .fullscreen
- .overFullscreen
- .replace

## Dismiss Presented View

You can get `routerPresentationMode` with `@Environment(\.routerPresentationMode) var routerPresentationMode`. You can dismiss or pop the view with routerPresentationMode like below:

```swift
Button("Dismiss") {
    routerPresentationMode.dismiss()
}
```

## Get Router In Child View

You can get `router` with `@EnvironmentObject var router: Router`. You can route to the any view with it.

```swift
struct DetailView: View {
    @EnvironmentObject
    var router: Router
    @Environment(\.routerPresentationMode)
    var routerPresentationMode
    
    var a: Int
    var b: String
    
    @Binding
    var test: Bool
    
    var body: some View {
        VStack {
            VStack {
                Text("a = \(a)")
                Text("b = \(b)")
                Toggle(isOn: $test) {
                    Text("Test Toggle")
                }
            }
            Button("Dismiss") {
                routerPresentationMode.dismiss()
            }
            .onAppear {
                print(routerPresentationMode.isPresented)
            }
            .onDisappear {
                print(routerPresentationMode.isPresented)
            }
            
            Button("Go to Three") {
                router.push {
                    Text("Three")
                    Button("push again") {
                        router.push {
                            Text("Hello World")
                            Button("Pop to Root") {
                                router.popToRoot()
                            }
                        }
                    }
                }
            }
        }
    }
}
```

## SwitchCaseView and IfLetView

For choosing view by variable value or optional value, Router provides SwitchCaseView and IfLetView. You can use them like below:

```swift
@main
struct RouterExampleApp: App {
    
    @Default(.isFirstLaunch)
    var isFirstLaunch
    
    var body: some Scene {
        WindowGroup {
            RouterRootView { router in
                Switch(isFirstLaunch)
                    .Case(true) { _ in
                        OnboardingView()
                    }
                    .Case(false) { _ in
                        ContentView()
                    }
                    .Else {
                        EmptyView()
                    }
            }
        }
    }
}
```

Or

```swift
var body: some Scene {
        WindowGroup {
            RouterRootView { router in
                Switch(isFirstLaunch)
                    .Case(true) { _ in
                        OnboardingView()
                    }
                    .Case(false) { _ in
                        ContentView()
                    }
                    .Else {
                        EmptyView()
                    }
            }
            .path("myapp://color") { data in
                Switch(data.color)
                    .Case("red") { color in
                        ColorView(color:  MyColor.from(string: color))
                            .navigationBarHidden(true)
                    }
                    .Case("green") { color in
                        ColorView(color:  MyColor.from(string: color))
                            .navigationBarHidden(true)
                    }
                    .Else {
                        Text("OMG")
                    }
            }
        }
}
```

Or

```swift
var body: some Scene {
        WindowGroup {
            RouterRootView { router in
                Switch(isFirstLaunch)
                    .Case(true) { _ in
                        OnboardingView()
                    }
                    .Case(false) { _ in
                        ContentView()
                    }
                    .Else {
                        EmptyView()
                    }
            }
            .path("myapp://color") { data in
                If(data.color).Let { color in
                    ColorView(color:  MyColor.from(string: color))
                        .navigationBarHidden(true)
                }
            }
        }
}
```

## Integration

###  Swift Package Manager

You can use The Swift Package Manager to install Router by adding the proper description to your Package.swift file:

```swift
// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(url: "https://github.com/ReactComponentKit/Router.git", from: "0.0.1"),
    ]
)
```

## MIT License

MIT License

Copyright (c) 2021 ReactComponentKit.Router

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
