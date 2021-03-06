precedencegroup Additional {
  associativity: left
  higherThan: Pipe
}

infix operator <>: Additional

public func <><A>(_ lhs: @escaping (A) -> A, _ rhs: @escaping (A) -> A) -> (A) -> A {
  lhs >>> rhs
}

public func <><A: AnyObject>(_ lhs: @escaping (A) -> Void, _ rhs: @escaping (A) -> Void) -> (A) -> Void {
  return { a in
    lhs(a)
    rhs(a)
  }
}

public func <><A>(_ lhs: @escaping (inout A) -> Void, _ rhs: @escaping (inout A) -> Void) -> (inout A) -> Void {
  return { a in
    lhs(&a)
    rhs(&a)
  }
}

public func <><A: Semigroup>(_ lhs: A, _ rhs: A) -> A {
  lhs + rhs
}
