import XCTest
@testable import FunctionalSwift

final class ContTests: XCTestCase {

  func doubleMe(_ value: Double) -> Double { value * 2 }

  func testPure() {
    let result = Cont<Double, Double>
      .pure(10.4)

    XCTAssertEqual(20.8, result.run(doubleMe))
  }

  func testMapPure() {
    let result = Cont { $0(100) }
      .map{ Double($0) }
      .run(doubleMe)

    XCTAssertEqual(200, result)
  }
}
