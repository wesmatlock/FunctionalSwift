import XCTest
@testable import FunctionalSwift

extension String: Error {}

final class OpertorKleisli: XCTestCase {

  func increment(_ value: Int?) -> Int? {
    guard let value = value else { return nil }
    return value + 1
  }

  func incrementValidation(_ value: Int) -> Result<Int, Error> {
    value < 0 ? .failure("Not Valid") : .success(value + 1)
  }

  func testOptionalComposition() {
    let increaseTwice = increment >=> increment

    let result = increaseTwice(nil)
    XCTAssertNil(result)

    let first: Int? = 10
    let second = increaseTwice(first)

    XCTAssertEqual(12, second)
    XCTAssertEqual(22, 20 |> increment >=> increment)
  }

  func testResultComposition() {
    let result = 10 |> incrementValidation >=> incrementValidation
    XCTAssertEqual(12, try result.get())
  }
}
