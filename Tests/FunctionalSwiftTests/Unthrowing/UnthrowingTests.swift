import XCTest
@testable import FunctionalSwift

final class UnthrowingTests: XCTestCase {

  enum CustomError: Error {
    case somethingWentWrong
  }

  func functionThatThrows() throws -> Int {
    throw CustomError.somethingWentWrong
  }

  func testThrowToResult() {
    let result: Result<Int, Error> = unThrow { try functionThatThrows() }
    switch result {
    case let .failure(error):
      XCTAssertTrue(error is CustomError, "Unexpected error type: \(type(of: error))")
    case .success:
      XCTAssert(true)
    }
  }

  func testThrowToResultAutoclousre()  {
    let result: Result<Int, Error> = unThrow(try functionThatThrows())
    switch result {
    case let .failure(error):
      XCTAssertTrue(error is CustomError, "Unexpected error type: \(type(of: error))")
    case .success:
      XCTAssert(true)
    }
  }

  func testThrowToEither() {

    let result: Either<Error, Int> = unThrow(try functionThatThrows())
    switch result {
    case let .left(error):
      XCTAssertTrue(error is CustomError,"Unexpected error type: \(type(of: error))")
    case .right:
      XCTAssert(true)
    }
  }
}
