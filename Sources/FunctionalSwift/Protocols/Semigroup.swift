public protocol Semigroup {
  static func + (_ lhs: Self, _ rhs: Self) -> Self
}

extension Numeric where Self: Semigroup {}

extension String: Semigroup {}
extension String.SubSequence: Semigroup {}

extension Array: Semigroup {}

extension Dictionary: Semigroup {
  public static func + (lhs: Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
    var copy = lhs
    rhs.keys.forEach { copy[$0] = rhs[$0] }
    return copy
  }
}

extension Bool: Semigroup {
  public static func + (lhs: Bool, rhs: Bool) -> Bool { lhs && rhs }
}
