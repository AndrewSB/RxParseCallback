# RxParseCallback
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

## API

#### Creating an Observable
```swift
func createWithCallback(_ callback: @escaping ((AnyObserver<T>) -> Void)) -> Observable<T>
```
Allows you to create an observable from a block. This is the meat of this µ Library. Inside the callback, you get a `AnyObserver<T>`, to which you can send any events you want propogated through the returned `Observable<T>`

#### Convinience functions for parsing conventional callback based APIs
Most APIs have callbacks that look something like `(SuccessDataType?, Error?)`. So there are three functions that help parsing data out of that common pattern.


###### Callbacks that return `(T, Error?)`
```swift 
func parseCallback<T>(_ observer: AnyObserver<T>) -> (T, Error?)
```
This works for callbacks that have callbacks that return `(SuccessDataType, Error?)`. So you pass in the `AnyObserver<T>` given to you from the `createWithCallback`, and it satisfies the type requirment of (T, Error?)


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
