import XCTest
import RxTest
import RxBlocking
import RxSwift
@testable import RxParseCallback

class CallbackBasedAPI {
    static func giveMeTheThing<T>(thing: T, callback: @escaping (T, Swift.Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
            callback(thing, .none)
        }
    }
}

class Rxifyed {
    static func giveMeTheThing<T>(thing: T) -> Observable<T> {
        return RxParseCallback.createWithCallback { observer in
            CallbackBasedAPI.giveMeTheThing(thing: thing, callback: RxParseCallback.parseCallback(observer))
        }
    }
}


class RxParseCallbackTests: XCTestCase {
    func testBasics() {
        let object = try? Rxifyed.giveMeTheThing(thing: "hi").toBlocking(timeout: 0.1).first()

        guard let maybeObject = object, let definitelyObject = maybeObject else {
            return XCTFail("got back nothing")
        }

        XCTAssertEqual(definitelyObject, "hi")
    }
}
