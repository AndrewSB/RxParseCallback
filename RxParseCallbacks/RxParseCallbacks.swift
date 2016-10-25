import Foundation
import RxSwift

public enum Error: Swift.Error {
    case noObjectNorErrorIncluded
}

public class ParseRxCallbacks {
    
    public static func createWithCallback<T>(_ callback: @escaping ((AnyObserver<T>) -> Void)) -> Observable<T> {
        return Observable.create { observer in
            callback(observer)
            return Disposables.create {}
        }
    }
    
    public static func parseCallback<T>(_ observer: AnyObserver<T>) -> (_ object: T, _ error: Swift.Error?) -> Void {
        return { (object: T, error: Swift.Error?) in
            guard error == nil else {
                return observer.on(.error(error!))
            }
            
            observer.on(.next(object))
            observer.on(.completed)
        }
    }
    
    public static func parseUnwrappedOptionalCallback<T>(_ observer: AnyObserver<T>) -> (_ object: T?, _ error: Swift.Error?) -> Void {
        return { (object: T?, error: Swift.Error?) in
            guard error == nil else {
                return observer.on(.error(error!))
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
    
    public static func parseOptionalCallback<T>(_ observer: AnyObserver<T?>) -> (_ object: T?, _ error: Swift.Error?) -> Void {
        return { (object: T?, error: Swift.Error?) in
            guard error == nil else {
                return observer.on(.error(error!))
            }
            
            observer.on(.next(object))
            observer.on(.completed)
        }
    }
    
}
