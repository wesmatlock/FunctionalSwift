precedencegroup Compose {
  associativity: left
  higherThan: Pipe, MapCompose
}

infix operator >>>: Compose

public func >>><A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> (A) -> C {
  return { a in g(f(a)) }
}
