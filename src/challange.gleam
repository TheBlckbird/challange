import gleam/io
import gleam/result
import lexer/lexer
import shunting_yards/shunting_yards

pub fn main() {
  let input = "3 v 5 + 7"

  input
  |> lexer.lexer
  |> result.unwrap([])
  |> shunting_yards.shunting_yards
  |> io.debug
}
