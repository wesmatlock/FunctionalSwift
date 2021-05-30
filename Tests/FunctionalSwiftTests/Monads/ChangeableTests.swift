import XCTest
@testable import FunctionalSwift

final class ChangeableTests: XCTestCase {

  struct Person: Equatable { var name: String, lastname: String }

  func testMap() {
    let result = Changeable(10)
      .map(String.init)

    XCTAssertEqual("10", result.value)
    XCTAssertEqual(result.hasChanges, false, "Should be changed since we changed interal to a string")

    let idenityResult = Changeable(10)
      .map(identity)

    XCTAssertEqual(10, idenityResult.value)
    XCTAssertEqual(idenityResult.hasChanges, false, "Should be false since we changed interal to a string")
  }

  func testWriteFlatMap() {
    let person = Person(name: "Thomas", lastname: "Jefferson")
    let result = Changeable<Person>(person)
      .flatMap(write("Thomas", at: \.name))
      .flatMap(write("Jefferson", at: \.lastname))

    XCTAssertFalse(result.hasChanges, "Should contain changes")
  }

  func testWriteBind() {
    let person = Person(name: "Thomas", lastname: "Jefferson")
    let result = Changeable<Person>(person)
      >>- write("Thomas", at: \.name)
      >>- write("Jefferson", at: \.lastname)

    XCTAssertFalse(result.hasChanges, "Should contain changes")  }
}
