import XCTest
@testable import FunctionalSwift

final class MonadicLawsTests: XCTestCase {
  private func upperCased(_ value: String) -> IO<String> {
    IO { value.uppercased() }
  }

  private func reversed(_ value: String) -> IO<String> {
    IO { String(value.reversed()) }
  }

  func testIOFirstMonadicLaw() {
    let monad = IO { "Good Morning Viatnam" }
    let first = monad.flatMap{ pure($0).map { $0.uppercased() } }
    let second = monad.map { $0.uppercased() }
    XCTAssertTrue(first == second)
  }

  func testIOSeconMonadicLaw() {
    let monad = IO { "Good Morning Viatnam" }
    let first = monad.flatMap(upperCased).flatMap(reversed)
    let second = monad.flatMap { self.upperCased($0).flatMap(self.reversed) }
    XCTAssertTrue(first == second)
  }
}
