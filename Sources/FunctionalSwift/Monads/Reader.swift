public struct Reader<Environment, Output> {

  public let run: (Environment) -> Output

  public init(run: @escaping (Environment) -> Output) {
    self.run = run
  }

  public func map<B>(_ f: @escaping (Output) -> B) -> Reader<Environment, B> {
    Reader<Environment, B> { r in f(self.run(r)) }
  }

  public func contraMap<EnvironmentB>(_ f: @escaping (EnvironmentB) -> Environment) -> Reader<EnvironmentB, Output> {
    Reader<EnvironmentB, Output> { b in self.run(f(b)) }
  }

  public func flatMap<B>(_ f: @escaping (Output) -> Reader<Environment, B>) -> Reader<Environment, B> {
    Reader<Environment, B> { r in f(self.run(r)).run(r) }
  }

  public func apply(_ environment: Environment) -> Output {
    self.run(environment)
  }
}

public func zip<Environment, A, B>(_ first: Reader<Environment, A>,_ second: Reader<Environment, B>)
-> Reader<Environment, (A, B)> {
  Reader { environment in (first.run(environment), second.run(environment)) }
}

public func zip<Envrionment, A, B, C>(_ first: Reader<Envrionment, A>, _ second: Reader<Envrionment, B>,
                                      _ third: Reader<Envrionment, C>) -> Reader<Envrionment, (A, B, C)> {
  zip(first, zip(second, third)).map { ($0.0, $0.1.0, $0.1.1) }
}

public func zip<Envrionment, A, B, C, D>(_ first: Reader<Envrionment, A>, _ second: Reader<Envrionment, B>,
                                         _ third: Reader<Envrionment, C>, _ forth: Reader<Envrionment, D>)
-> Reader<Envrionment, (A, B, C, D)> {
  zip(first, zip(second, third, forth))
    .map { ($0.0, $0.1.0, $0.1.1, $0.1.2) }
}

public func zip<Environment, A, B, C, D, E>(_ first: Reader<Environment, A>, _ second: Reader<Environment, B>,
                                            _ third: Reader<Environment, C>, _ forth: Reader<Environment, D>,
                                            _ fifth: Reader<Environment, E>) -> Reader<Environment, (A, B, C, D, E)> {
  zip(first, zip(second, third, forth, fifth))
    .map { ($0.0, $0.1.0, $0.1.1, $0.1.2, $0.1.3) }
}

public func zip<Environment, A, B, C, D, E, F>(_ first: Reader<Environment, A>, _ second: Reader<Environment, B>,
                                               _ third: Reader<Environment, C>, _ forth: Reader<Environment, D>,
                                               _ fifth: Reader<Environment, E>, _ sixth: Reader<Environment, F>)
-> Reader<Environment, (A, B, C, D, E, F)> {
  zip(first, zip(second, third, forth, fifth, sixth))
    .map { ($0.0, $0.1.0, $0.1.1, $0.1.2, $0.1.3, $0.1.4) }
}

public func zip<Environment, A, B, Output>(with f: @escaping (A, B) -> Output, _ lhs: Reader<Environment, A>,
                                           _ rhs: Reader<Environment, B>) -> Reader<Environment, Output> {
  zip(lhs, rhs).map(f)
}

public func zip<Environment, A, B, C, Output>(with f: @escaping (A, B, C) -> Output, _ first: Reader<Environment, A>,
                                              _ second: Reader<Environment, B>, _ third: Reader<Environment, C>)
-> Reader<Environment, Output> {
  zip(first, second, third).map(f)
}

public func zip<Environment, A, B, C, D, Output>(with f: @escaping (A, B, C, D) -> Output, _ first: Reader<Environment, A>,
                                                 _ second: Reader<Environment, B>, _ third: Reader<Environment, C>,
                                                 _ forth: Reader<Environment, D>) -> Reader<Environment, Output> {
  zip(first, second, third, forth).map(f)
}

public func zip<Environment, A, B, C, D, E, Output>(with f: @escaping (A, B, C, D, E) -> Output,
                                                    _ first: Reader<Environment, A>, _ second: Reader<Environment, B>,
                                                    _ third: Reader<Environment, C>, _ forth: Reader<Environment, D>,
                                                    _ fifth: Reader<Environment, E>) -> Reader<Environment, Output> {
  zip(first, second, third, forth, fifth).map(f)
}

public func zip<Environment, A, B, C, D, E, F, Output>(with f: @escaping (A, B, C, D, E, F) -> Output,
                                                       _ first: Reader<Environment, A>, _ second: Reader<Environment, B>,
                                                       _ third: Reader<Environment, C>, _ forth: Reader<Environment, D>,
                                                       _ fifth: Reader<Environment, E>, _ sixth: Reader<Environment, F>)
-> Reader<Environment, Output> {
  zip(first, second, third, forth, fifth, sixth).map(f)
}
