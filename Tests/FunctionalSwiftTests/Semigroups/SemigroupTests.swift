import XCTest
@testable import FunctionalSwift

enum TextAlignment {
  case left, center, right
}

class FakeLabel {
  var text: String?
  var alignment: TextAlignment = .left
}

final class SemigroupTests: XCTestCase {
  func increment(_ value: inout Int) -> Void { value += 1 }
  func multiply(_ value: inout Int) -> Void { value += 1 }

  func testSemigroupArray() {
    let result = [1, 4, 3] <> [2, 3, 4]
    XCTAssertEqual([1, 4, 3, 2, 3, 4], result)
  }

  func testSemigroupString() {
    let result = "Hello" <> " world"
    XCTAssertEqual("Hello world", result)
  }

  func testSemigroupBool() {
    XCTAssertEqual(true, true <> true)
    XCTAssertEqual(false, true <> false)
    XCTAssertEqual(false, false <> true)
    XCTAssertEqual(false, false <> false)
  }

  func testSemigroupFunctions() {
    let increment: (Int) -> Int = { $0 + 1}
    let multiply: (Int) -> Int = { $0 * $0 }

    let multiplyAndIncrement = multiply <> increment
    XCTAssertEqual(101, multiplyAndIncrement(10))
  }

  func testSemigroupReferenceType() {

    let uppercasedStyle: (FakeLabel) -> Void = { $0.text = $0.text?.uppercased() }
    let rightAlignStyle: (FakeLabel) -> Void = { $0.alignment = .right }
    let label = FakeLabel()
    label.text = "Check me out"

    let uppcasedRightAlignStyle = uppercasedStyle <> rightAlignStyle
    uppcasedRightAlignStyle(label)

    XCTAssertEqual("CHECK ME OUT", label.text)
    XCTAssertEqual(.right, label.alignment)
  }
}


