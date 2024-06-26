import gleam/list
import gleam/string
import gleam/float
import gleam/result
import lexer/tokens

pub fn lexer(input: String) -> Result(List(tokens.Token), Nil) {
  lexer_recur(input, [])
}

fn lexer_recur(
  remaining: String,
  tokens: List(tokens.Token),
) -> Result(List(tokens.Token), Nil) {
  let new_remaining = string.drop_left(remaining, 1)

  case string.first(remaining) {
    Error(_) -> Ok(tokens)

    Ok(char) -> {
      case char {
        ")" ->
          lexer_recur(new_remaining, list.append(tokens, [tokens.CloseBracket]))
        "(" ->
          lexer_recur(new_remaining, list.append(tokens, [tokens.OpenBracket]))
        "+" ->
          lexer_recur(
            new_remaining,
            list.append(tokens, [tokens.Operator(tokens.Add)]),
          )
        "-" ->
          lexer_recur(
            new_remaining,
            list.append(tokens, [tokens.Operator(tokens.Sub)]),
          )
        "*" ->
          lexer_recur(
            new_remaining,
            list.append(tokens, [tokens.Operator(tokens.Mul)]),
          )
        "/" ->
          lexer_recur(
            new_remaining,
            list.append(tokens, [tokens.Operator(tokens.Div)]),
          )
        "!" ->
          lexer_recur(
            new_remaining,
            list.append(tokens, [tokens.Operator(tokens.Fact)]),
          )
        "%" ->
          lexer_recur(
            new_remaining,
            list.append(tokens, [tokens.Operator(tokens.Mod)]),
          )
        "^" ->
          lexer_recur(
            new_remaining,
            list.append(tokens, [tokens.Operator(tokens.Pow)]),
          )
        "v" ->
          lexer_recur(
            new_remaining,
            list.append(tokens, [tokens.Operator(tokens.Tetr)]),
          )

        "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0" -> {
          let number_result =
            string.drop_left(remaining, 1)
            |> parse_number(char)

          case number_result {
            Ok(number) ->
              lexer_recur(
                number.0,
                list.append(tokens, [tokens.Number(number.1)]),
              )

            Error(_) -> Error(Nil)
          }
        }

        " " | "\n" -> lexer_recur(new_remaining, tokens)

        _ -> {
          Error(Nil)
        }
      }
    }
  }
}

fn parse_number(
  remaining: String,
  number_til_now: String,
) -> Result(#(String, Float), Nil) {
  let return = fn() {
    case
      string.last(number_til_now)
      |> result.unwrap(",")
    {
      "." -> Error(Nil)
      _ -> {
        let number = case string.contains(number_til_now, ".") {
          True -> number_til_now
          False -> string.append(number_til_now, ".0")
        }

        case
          number
          |> float.parse
        {
          Ok(parsed_number) -> Ok(#(remaining, parsed_number))
          Error(_) -> Error(Nil)
        }
      }
    }
  }

  case string.first(remaining) {
    Error(Nil) -> return()

    Ok(char) -> {
      case char {
        "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0" | "." ->
          parse_number(
            string.drop_left(remaining, 1),
            string.append(number_til_now, char),
          )

        "," | "_" ->
          parse_number(string.drop_left(remaining, 1), number_til_now)

        _ -> return()
      }
    }
  }
}
