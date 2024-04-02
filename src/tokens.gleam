pub type Tokens {
  Number(Float)
  Operation(Operation)
  OpenBracket
  CloseBracket
}

pub type Operation {
  Add
  Sub
  Mul
  Div
  Fact
  Mod
  Pow
  Tetr
}
