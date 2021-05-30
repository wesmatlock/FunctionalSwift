import XCTest
@testable import FunctionalSwift

final class OperatorFunctor: XCTestCase {

  func increment(_ value: Int) -> Int { value + 1}
  func uppercased(_ value: String) -> String { value.uppercased() }
  func lowercased(_ value: String) -> String { value.lowercased() }

  func testArrayMap() {
    let result = [1, 2, 3] <&> increment
    XCTAssertEqual([2, 3, 4], result)
  }

  func testOptionalMap() {
    let str: String? = "Drive a fast car" <&> uppercased
    XCTAssertEqual("DRIVE A FAST CAR", str)
  }

  func testResultMap() {
    let result = Result.success(10) <&> increment
    try XCTAssertEqual(11, result.get())
  }

  func testIOMap() {
    let result = IO { "Hello Good Looking" } <&> uppercased
    XCTAssertEqual("HELLO GOOD LOOKING", result.unsafeRun())
  }

  func testEitherRightMap() {
    let eitherResult = Either<String, String>.right("highway to hell") <&> uppercased
    XCTAssertEqual("HIGHWAY TO HELL", eitherResult.right())
  }

  func testEitherLeftMap() {
    let eitherResult = Either<String, String>.left("failure is not an option") <&> uppercased
    XCTAssertNotEqual("HELLO WORLD", eitherResult.left())
    XCTAssertNotEqual("HELLO WORLD", eitherResult.right())

    XCTAssertEqual("failure is not an option", eitherResult.left())
  }

  func testDeferredMap() {
    let deferred = Deferred { $0("Race Day") } <&> uppercased
    deferred.run { result in
      XCTAssertEqual("RACE DAY", result)
    }
  }

  func testReaderMap() {
    let reader = Reader<String, String> { "Hello \($0)" } <&> uppercased
    XCTAssertEqual("HELLO GOOD LOOKING", reader.run("good looking"))
  }


  func testChangeableMap() {
    let changeable = Changeable("What's up") <&> uppercased
    XCTAssertEqual("WHAT'S UP", changeable.value)
    XCTAssertFalse(changeable.hasChanges)
  }

  func testStateMap() {
    let state = State<Bool, String> { state in
      (state, state ? "HELLO WORLD" : "Hello world")
    }
    XCTAssertEqual("HELLO WORLD", state.eval(state: true))
    XCTAssertEqual("Hello world", state.eval(state: false))

    /// Override
    XCTAssertEqual("HELLO WORLD", (state <&> uppercased).eval(state: false))
    XCTAssertEqual("hello world", (state <&> lowercased).eval(state: true))

  }
}
