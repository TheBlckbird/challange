import gleam/list
import lexer/tokens

pub fn shunting_yards(tokens_list: List(tokens.Token)) -> List(tokens.Token) {
  shunting_yards_recur(tokens_list, [], [])
}

fn shunting_yards_recur(
  tokens_left: List(tokens.Token),
  stack: List(tokens.Token),
  output: List(tokens.Token),
) -> List(tokens.Token) {
  case list.first(tokens_left) {
    Error(Nil) -> output
    Ok(token) ->
      case token {
        tokens.Number(_) ->
          shunting_yards_recur(
            list.drop(tokens_left, 1),
            stack,
            list.append(output, [token]),
          )
        tokens.Operator(operator) -> todo
        tokens.OpenBracket -> todo
        tokens.CloseBracket -> todo
      }
  }
}
