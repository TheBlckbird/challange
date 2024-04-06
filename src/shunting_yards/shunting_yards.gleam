import gleam/list
import gleam/io
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
    Error(Nil) -> {
      stack
      |> list.reverse
      |> list.append(output, _)
    }
    Ok(token) ->
      case token {
        tokens.Number(_) ->
          shunting_yards_recur(
            list.drop(tokens_left, 1),
            stack,
            list.append(output, [token]),
          )
        tokens.Operator(_) -> {
          case list.last(stack) {
            Error(_) ->
              shunting_yards_recur(
                list.drop(tokens_left, 1),
                list.append(stack, [token]),
                output,
              )
            Ok(top_stack_operator) -> {
              let current_precedence = tokens.get_precedence_level(token)
              let stack_precedence =
                tokens.get_precedence_level(top_stack_operator)

              case current_precedence {
                _ if current_precedence <= stack_precedence -> {
                  let operator_popped = pop_operators(token, stack, output)

                  shunting_yards_recur(
                    list.drop(tokens_left, 1),
                    operator_popped.0,
                    operator_popped.1,
                  )
                }
                _ -> {
                  shunting_yards_recur(
                    list.drop(tokens_left, 1),
                    list.append(stack, [token]),
                    output,
                  )
                }
              }
            }
          }
          // let operator_popped = pop_operators(token, stack, output)

          // shunting_yards_recur(
          //   list.drop(tokens_left, 1),
          //   operator_popped.0,
          //   operator_popped.1,
          // )
        }
        tokens.OpenBracket ->
          shunting_yards_recur(
            list.drop(tokens_left, 1),
            list.append(stack, [token]),
            output,
          )
        tokens.CloseBracket -> todo
      }
  }
}

fn pop_operators(
  operator: tokens.Token,
  stack: List(tokens.Token),
  output: List(tokens.Token),
) -> #(List(tokens.Token), List(tokens.Token)) {
  case list.last(stack) {
    Ok(token) -> {
      let operator_precedence = tokens.get_precedence_level(operator)
      let curr_token_precedence = tokens.get_precedence_level(token)

      case curr_token_precedence {
        _ if operator_precedence <= curr_token_precedence -> {
          pop_operators(
            operator,
            list.drop(stack, 1),
            list.append(output, [token]),
          )
        }

        _ -> {
          #(list.append(stack, [operator]), output)
        }
      }
    }

    Error(_) -> #(list.append(stack, [operator]), output)
  }
}
