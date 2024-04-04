import gleam/io
import lexer/lexer

pub fn main() {
  let input = "(3 + 5) * 7"

  input
  |> lexer.lexer
  |> io.debug
}
