import Foundation
import RxSwift

public enum Error: Swift.Error {
    case noObjectNorErrorIncluded
}

class ParseRxCallbacks {
    
    static func createWithCallback<T>(_ callback: @escaping ((AnyObserver<T>) -> Void)) -> Observable<T> {
        return Observable.create({ (observer: AnyObserver<T>) -> Disposable in
            callback(observer)
            return Disposables.create {}
        })
    }
    
    static func rx_parseCallback<T>(_ observer: AnyObserver<T>) -> (_ object: T, _ error: Error?) -> Void {
        return { (object: T, error: Error?) in
            guard error == nil else {
                observer.on(.error(error!))
            }
            
            observer.on(.next(object))
            observer.on(.completed)
        }
    }
    
    static func rx_parseUnwrappedOptionalCallback<T>(_ observer: AnyObserver<T>) -> (_ object: T?, _ error: Error?) -> Void {
        return { (object: T?, error: Error?) in
            guard error == nil else {
                observer.on(.error(error!))
            }
            
            switch object {
            case .some(let obj):
                observer.on(.next(obj))
                observer.on(.completed)
            case .none:
                observer.on(.error(Error.noObjectNorErrorIncluded))
            }
        }
    }
    
    static func rx_parseOptionalCallback<T>(_ observer: AnyObserver<T?>) -> (_ object: T?, _ error: Error?) -> Void {
        return { (object: T?, error: Error?) in
            guard error == nil else {
                observer.on(.error(error!))
            }
            
            observer.on(.next(object))
            observer.on(.completed)
        }
    }
    
}
