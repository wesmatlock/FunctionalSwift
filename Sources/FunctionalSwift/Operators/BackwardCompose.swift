precedencegroup BackwardCompose {
  associativity: left
  higherThan: Pipe, MapCompose
}

infix operator <<<: BackwardCompose

public func <<< <A, B, C>(_ g: @escaping (B) -> C, _ f: @escaping (A) -> B) -> (A) -> (C) {
  return { a in g(f(a)) }
}
