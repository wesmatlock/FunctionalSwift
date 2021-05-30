import XCTest
@testable import FunctionalSwift

final class DictionaryTests: XCTestCase {

  func testSemiGroup() {
    let result: [String: String] = ["Json": "Accept"] <> ["Bearer": "Token"]
    XCTAssertEqual(result["Json"], "Accept")
    XCTAssertEqual(result["Bearer"], "Token")
  }
}
