pub type Token {
  Number(Float)
  Operator(Operator)
  OpenBracket
  CloseBracket
}

pub type Operator {
  Add
  Sub
  Mul
  Div
  Fact
  Mod
  Pow
  Tetr
}

pub fn get_precedence_level(operator: Operator) -> Int {
  case operator {
    Add -> 1
    Sub -> 1
    Mul -> 2
    Div -> 2
    Fact -> 4
    Mod -> 2
    Pow -> 3
    Tetr -> 3
  }
}
