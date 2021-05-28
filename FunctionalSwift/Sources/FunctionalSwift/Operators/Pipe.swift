precedencegroup Pipe { associativity: left }
infix operator |>: Pipe

public func |><A, B>(_ value: A, _ f: @escaping (A) -> B) -> B {
  return f(value)
}

public func |><A, B>(_ value: A, _ f: @escaping (inout A) -> B) -> B {
  var copy = value
  return f(&copy)
}
