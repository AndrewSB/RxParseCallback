import Foundation
import RxSwift

class ParseRxCallbacks {
    
    static func createWithCallback<T>(_ callback: @escaping ((AnyObserver<T>) -> Void)) -> Observable<T> {
        return Observable.create({ (observer: AnyObserver<T>) -> Disposable in
            callback(observer)
            return Disposables.create {}
        })
    }
    
    static func rx_parseCallback<T>(_ observer: AnyObserver<T>) -> (_ object: T, _ error: Error?) -> Void {
        return { (object: T, error: Error?) in
            if error == nil {
                observer.on(.next(object))
                observer.on(.completed)
            } else {
                observer.on(.error(error!))
            }
        }
    }
    
    static func rx_parseUnwrappedOptionalCallback<T>(_ observer: AnyObserver<T>) -> (_ object: T?, _ error: Error?) -> Void {
        return { (object: T?, error: Error?) in
            if error == nil {
                observer.on(.next(object!))
                observer.on(.completed)
            } else {
                observer.on(.error(error!))
            }
        }
    }
    
    static func rx_parseOptionalCallback<T>(_ observer: AnyObserver<T?>) -> (_ object: T?, _ error: Error?) -> Void {
        return { (object: T?, error: Error?) in
            if error == nil {
                observer.on(.next(object))
                observer.on(.completed)
            } else {
                observer.on(.error(error!))
            }
        }
    }
    
}
