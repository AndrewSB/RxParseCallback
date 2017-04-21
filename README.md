# RxParseCallback

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

Syntactic sugar to convert block based callbacks into RxSwift Observables


## Usage 

Are you tied down to a callback based API, wishfully looking on at RxSwift?
RxParseCallback makes adopting RxSwift in your project way easier!

```swift
/// This is a real example from a codebase I've worked on. It wraps the Facebook SDK's login function
func login(withReadPermissions permissions: [String] = ["email", "public_profile", "user_friends"]) -> Observable<FBSDKLoginManagerLoginResult> {

  return ParseRxCallbacks.createWithCallback({ observer -> Void in
    FBSDKLoginManager().logIn(withReadPermissions: permissions, 
                              from: nil,
                              // the `handler` param is of type `(FBSDKLoginManagerLoginResult?, Error?) -> Swift.Void`, 
                              // and calling `ParseRxCallbacks.parseUnwrappedOptionalCallback(observer)` returns `(T?, Error?) -> Swift.Void`
                              // #connectingmagic
                              handler: ParseRxCallbacks.parseUnwrappedOptionalCallback(observer))
  })

}
```

## Installation

`RxParseCallback` is tiny — it's just one file — 55 lines

These are the currently supported methods of installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.

```swift
import PackageDescription

let package = Package(
    name: "MyProjectThat<3sRx",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/AndrewSB/RxParseCallback.git", majorVersion: 1)
    ]
)
```

```bash
$ swift build
```

### [Carthage](https://github.com/Carthage/Carthage)

Add this to `Cartfile`

```
github "AndrewSB/RxParseCallback" ~> 1.0
```

```bash
$ carthage update
```

### Manual

First make sure you have access to [`RxSwift`](https://github.com/ReactiveX/RxSwift/blob/master/README.md#manual) in your project.
Then you can grab the Source/RxParseCallback.swift file, and drag it into your project.

## API

#### Creating an Observable
```swift
func createWithCallback(_ callback: @escaping ((AnyObserver<T>) -> Void)) -> Observable<T>
```
Allows you to create an observable from a block. This is the meat of this µ Library. Inside the callback, you get a `AnyObserver<T>`, to which you can send any events you want propogated through the returned `Observable<T>`

#### Convinience functions for parsing conventional callback based APIs
Most APIs have callbacks that look something like `(T?, Error?)`. So there are three functions that help parsing data out of that common pattern.


###### Callbacks that return `(T, Error?)`
```swift 
func parseCallback<T>(_ observer: AnyObserver<T>) -> (T, Error?)
```
This works for callbacks that have callbacks that return `(T, Error?)`. So you pass in the `AnyObserver<T>` given to you from the `createWithCallback`, and it satisfies the type requirment of (T, Error?)


###### Callbacks that return `(T?, Error?)`
```swift 
func parseOptionalCallback<T>(_ observer: AnyObserver<T?>) -> (T?, Error?)
```
Same as above, but it accepts callbacks that pass in `(T?, Error?)` instead.

###### Callbacks that return `(T?, Error?)`
```swift 
func parseUnwrappedOptionalCallback<T>(_ observer: AnyObserver<T>) -> (T?, Error?)
```
Same as above, but it also goes ahead and (safely) unwraps the `T?` into a `T` if the error was nil. 
If both the error and `T` are `nil`, it sends an error through on the Observable, called `noObjectNorErrorIncluded`

## License

**RxParseCallback** is under the MIT license. See the [LICENSE](https://github.com/AndrewSB/RxParseCallback/blob/master/LICENSE) file for more info.
