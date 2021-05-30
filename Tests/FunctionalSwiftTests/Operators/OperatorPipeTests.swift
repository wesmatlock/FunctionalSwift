import XCTest
@testable import FunctionalSwift

final class OperatorPipe: XCTestCase {

  func increment(_ value: Int) -> Int { value + 1 }

  func increment(_ value: IO<Int>) -> IO<Int> { value.map(increment) }
  func increment(_ value: Deferred<Int>) -> Deferred<Int> { value.map(increment)}
  func increment(_ value: Changeable<Int>) -> Changeable<Int> { value.map(increment) }

  func testIncreaseValue() {
    let result = 10 |> increment
    XCTAssertEqual(11, result)
  }

  func testPipeIO() {
    let result = IO { 10 } |> increment
    XCTAssertEqual(11, result.unsafeRun())
  }

  func testPipeChangeable() {
    let result = Changeable(10) |> increment
    XCTAssertEqual(11, result.value)
  }

  func testPipeDeferred() {
    let deferred = Deferred(10) |> increment
    let expectation = XCTestExpectation(description: "Waiting...")

    deferred.run { result in
      XCTAssertEqual(11, result)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.1)
  }
}
