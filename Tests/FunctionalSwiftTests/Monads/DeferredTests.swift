import XCTest
@testable import FunctionalSwift

final class DeferredTests: XCTestCase {

  func testDelayed() {
    let expectation = XCTestExpectation(description: "Waiting...")
    let result = Deferred.delayed(by: 1) { 10 }

    result.run { value in
      XCTAssertEqual(10, value)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.1)
  }

  func testDelayIO() {
    let expectation = XCTestExpectation(description: "Waiting...")
    let result = Deferred.delayed(by: 1, withIO: IO { 10 })

    result.run { value in
      XCTAssertEqual(10, value)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.1)
  }

  func testInitFromIO() {
    let expectation = XCTestExpectation(description: "Waiting...")
    let result = zip(Deferred(10), Deferred(io: IO { 10 }))

    result.run { first, second in
      XCTAssertEqual(10, first)
      XCTAssertEqual(10, second)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.2)
  }

  func testMap() {
    let expectation = XCTestExpectation(description: "Waiting...")
    let result = Deferred(10)
      .map(String.init)

    result.run { value in
      XCTAssertEqual("10", value)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 2)
  }

  func testZip2() {
    let expectation = XCTestExpectation(description: "Waiting...")
    let result = zip(
      Deferred { $0(10) },
      Deferred.delayed(by: 1) { "Good Morning Vietnam!"})

    result.run { first, second in
      XCTAssertEqual(10, first)
      XCTAssertEqual("Good Morning Vietnam!", second)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.1)
  }

  func test3() {
    let expectation = XCTestExpectation(description: "Waiting...")

    let result = zip(
      Deferred { $0(10) },
      Deferred.delayed(by: 1) { "This is a test" },
      Deferred { $0(10.2) })

    result.run { first, second, third in
      XCTAssertEqual(10, first)
      XCTAssertEqual("This is a test", second)
      XCTAssertEqual(10.2, third)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.1)
  }

  func testZip4() {
    let expectation = XCTestExpectation(description: "Waiting...")

    let result = zip(
      Deferred { $0(10) },
      Deferred.delayed(by: 1) { "Hello..."},
      Deferred { $0(10.2) },
      Deferred.delayed(by: 1) { URL(string: "http://www.apple.com") })

    result.run { first, second, third, forth in
      XCTAssertEqual(10, first)
      XCTAssertEqual("Hello...", second)
      XCTAssertEqual(10.2, third)
      XCTAssertNotNil(forth, "Shouldn't be nil")
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.1)
  }

  func testZip5() {

    let expectation = XCTestExpectation(description: "Waiting...")

    let result = zip(
      Deferred { $0(10) },
      Deferred.delayed(by: 0.7) { 10 },
      Deferred.delayed(by: 0.5) { 10.2 },
      Deferred.delayed(by: 0.9) { "Hello world" },
      Deferred { $0("I'm a Callback") }
    )
    result.run { first, second, third, forth, fifth in
      XCTAssertEqual(10, first)
      XCTAssertEqual(10, second)
      XCTAssertEqual(10.2, third)
      XCTAssertEqual("Hello world", forth)
      XCTAssertEqual("I'm a Callback", fifth)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
  }

  func testZip6() {
    let expectation = XCTestExpectation(description: "Waiting...")

    let result = zip(
      Deferred { $0(10) },
      Deferred.delayed(by: 0.3) { 10 },
      Deferred.delayed(by: 0.2) { 10.2 },
      Deferred.delayed(by: 0.3) { "Hello world" },
      Deferred { $0("I'm a Callback") },
      Deferred(io: IO { 101 })
    )
    result.run { first, second, third, forth, fifth, sixth in
      XCTAssertEqual(10, first)
      XCTAssertEqual(10, second)
      XCTAssertEqual(10.2, third)
      XCTAssertEqual("Hello world", forth)
      XCTAssertEqual("I'm a Callback", fifth)
      XCTAssertEqual(101, sixth)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.31)
  }

  func testZip7() {
    let expectation = XCTestExpectation(description: "Waiting...")

    let result = zip(
      Deferred { $0(10) },
      Deferred.delayed(by: 0.2) { 10 },
      Deferred.delayed(by: 0.3) { 10.2 },
      Deferred.delayed(by: 0.5) { "Hello world" },
      Deferred { $0("Hello Callback") },
      Deferred(io: IO { 101 })
    )

    result.run { first, second, third, forth, fifth, sixth in
      XCTAssertEqual(10, first)
      XCTAssertEqual(10, second)
      XCTAssertEqual(10.2, third)
      XCTAssertEqual("Hello world", forth)
      XCTAssertEqual("Hello Callback", fifth)
      XCTAssertEqual(101, sixth)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.55)
  }

  func testInitPureTResult() {
    let expectation = XCTestExpectation(description: "Waiting...")
    let result = Deferred<Result<Int, Error>>.pureT(10)

    result.run { result in
      XCTAssertEqual(10, try! result.get())
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.55)
  }

  func testInitPureTOptional() {
    let expectation = XCTestExpectation(description: "Waiting...")
    let result = Deferred<Int?>.pureT(10)
    result.run { result in
      XCTAssertEqual(10, result)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.55)
  }

  func testAnyCanceableDeferred() {
    var deferredInt = Deferred.delayed(by: 0.1) { 10 }
    var deferredString = Deferred.delayed(by: 0.1) { "The world is on fire" }

    let expecationInt = XCTestExpectation(description: "Waiting for Int..")
    let expecationString = XCTestExpectation(description: "Waiting for String..")

    deferredInt.onCancel = {
      expecationInt.fulfill()
    }
    deferredString.onCancel = {
      expecationString.fulfill()
    }

    let canceable: [AnyCancellableDeferred] = [deferredInt, deferredString]
    canceable.forEach { $0.cancel() }

    wait(for: [expecationString, expecationInt], timeout: 2)
  }

  func testCancelZip() {

    var deferredWithInt = Deferred
      .delayed(by: 0.1) { 10 }
      .map(String.init)

    var deferredWithString = Deferred
      .delayed(by: 0.1) { "Hello World" }

    let expectationInt = XCTestExpectation(description: "WaitingInt")
    let expectationString = XCTestExpectation(description: "WaitingString")

    deferredWithInt.onCancel = {
      expectationInt.fulfill()
    }

    deferredWithString.onCancel = {
      expectationString.fulfill()
    }

    let newResult = zip(deferredWithInt, deferredWithString)
    newResult.cancel()

    debugPrint(newResult)

    wait(for: [expectationInt, expectationString], timeout: 2)
  }

  func testCancelThenMap() {

    var deferredWithInt = Deferred
      .delayed(by: 0.1) { 10 }
      .map(String.init)

    let expectation = XCTestExpectation(description: "WaitingInt")

    deferredWithInt.onCancel = {
      expectation.fulfill()
    }

    deferredWithInt.cancel()
    debugPrint(deferredWithInt)
    wait(for: [expectation], timeout: 1)
  }
}

