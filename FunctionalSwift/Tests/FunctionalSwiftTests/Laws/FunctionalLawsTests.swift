import XCTest
@testable import FunctionalSwift

final class FunctionalLawsTests: XCTestCase {

  func reversed(_ str: String) -> String { String(str.reversed()) }

  // MARK: - Optionals
  func testIdentityOptional() {
    let checkValue = 10
    let result = Optional<Int>.some(checkValue) <&> identity
    XCTAssertEqual(checkValue, result)

    let result2 = Optional<Int>.some(checkValue).map(identity)
    XCTAssertEqual(checkValue, result2)
  }

  func testCompositionOptional() {
    let result = Optional<Int>.some(10)
      .map(String.init)
      .map(reversed)

    XCTAssertEqual("01", result)

    let result2 = Optional<Int>.some(10)
      .map(String.init >>> reversed)
    XCTAssertEqual("01", result2)
  }

// MARK: - IO<A>
  func testIdentityIO() {
    let checkValue = 10

    let result = IO { checkValue } <&> identity
    XCTAssertEqual(checkValue, result.unsafeRun())

    let result2 = IO { checkValue }.map(identity)
    XCTAssertEqual(checkValue, result2.unsafeRun())
  }

  func testFunctorCompositionIO() {
    let checkValue = 10
    let first = IO { checkValue }.map(String.init).map(reversed)
    let second = IO { checkValue }.map(String.init >>> reversed)
    let third = IO { checkValue } <&> String.init >>> reversed

    XCTAssertEqual(first, second)
    XCTAssertEqual(first, third)
  }

  // MARK: - Deferred<A>
  func testIdentityDeferred() {
    let checkValue = 10

    let firstDeferred = Deferred(checkValue) <&> identity
    let secondDeferred = Deferred(checkValue).map(identity)

    let firstExpectation = XCTestExpectation(description: "Deferred wait first")
    let secondExpectation = XCTestExpectation(description: "Deferred wait second")

    firstDeferred.run { result in
      XCTAssertEqual(checkValue, result)
      firstExpectation.fulfill()
    }

    secondDeferred.run { result in
      XCTAssertEqual(checkValue, result)
      secondExpectation.fulfill()
    }
    wait(for: [firstExpectation, secondExpectation], timeout: 0.1)
  }

  func testFunctorCompositionDeferred() {
    let firstDeferred = Deferred(10) <&> String.init >>> reversed
    let secondDeferred = Deferred(10).map(String.init >>> reversed)

    let firstExpectation = XCTestExpectation(description: "Deferred wait first")
    let secondExpectation = XCTestExpectation(description: "Deferred wait second")

    firstDeferred.run { result in
      XCTAssertEqual("01", result)
      firstExpectation.fulfill()
    }

    secondDeferred.run { result in
      XCTAssertEqual("01", result)
      secondExpectation.fulfill()
    }
    wait(for: [firstExpectation, secondExpectation], timeout: 0.1)
  }

  func testIdentityReader() {
    let reader = Reader<Int, Int> { $0 }
      .map(String.init)
      .map(reversed)

    XCTAssertEqual("01", reader.run(10))
  }

  func testCompositionReader() {
    let result = Reader<Int, Int> { $0 }
      .map(String.init >>> reversed)
    XCTAssertEqual("01", result.run(10))

    let result2 = Reader<Int, Int> { $0 } <&> String.init >>> reversed
    XCTAssertEqual("01", result2.run(10))
  }

  func testMapTResult() {
    let ioResult = IO<Result<Int, Error>> { .success(101) }
    let result = ioResult.mapT(String.init)
    XCTAssertEqual("101", try result.unsafeRun().get())
  }

  func testMapTIOOptional() {
    let ioResult = IO<Optional<Int>> { 101 }
    let result = ioResult.mapT(String.init)
    XCTAssertEqual("101", result.unsafeRun())
  }

  func testMapTDeferredOptional() {

    let deferred = Deferred<Optional<Int>>.pureT(101)
      .mapT(String.init)

    let expectation = XCTestExpectation(description: "Deferred wait first")

    deferred.run { result in
      XCTAssertEqual(result, "101")
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.1)
  }

  func testMapTDeferredResult() {
    let deferred = Deferred<Result<Int, Error>>.pureT(101)
      .mapT(String.init)

    let expectation = XCTestExpectation(description: "Deferred wait first")

    deferred.run { result in
      XCTAssertEqual(try! result.get(), "101")
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.1)
  }

}
