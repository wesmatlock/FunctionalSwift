public func unThrow<A>(
  _ f: @autoclosure () throws -> A) -> Result<A, Error> {
  Result(catching: f)
}

public func unThrow<A>(_ f: () throws -> A) -> Result<A, Error> {
  Result(catching: f)
}

public func unThrow<A>(_ f: @autoclosure () throws -> A) -> Either<Error, A> {
  Either(cathing: f)
}

public func unThrow<A>(_ f: () throws -> A) -> Either<Error, A> {
  Either(cathing: f)
}
