import gleam/list
import gleam/string
import gleam/float
import gleam/result
import lexer/tokens

pub fn lexer(input: String) -> Result(List(tokens.Token), Nil) {
  lexer_loop(input, [])
}

fn lexer_loop(
  remaining: String,
  tokens: List(tokens.Token),
) -> Result(List(tokens.Token), Nil) {
  let new_remaining = string.drop_left(remaining, 1)

  case string.first(remaining) {
    Error(_) -> Ok(tokens)

    Ok(char) -> {
      case char {
        ")" ->
          lexer_loop(new_remaining, list.append(tokens, [tokens.CloseBracket]))
        "(" ->
          lexer_loop(new_remaining, list.append(tokens, [tokens.OpenBracket]))
        "+" ->
          lexer_loop(
            new_remaining,
            list.append(tokens, [tokens.Operation(tokens.Add)]),
          )
        "-" ->
          lexer_loop(
            new_remaining,
            list.append(tokens, [tokens.Operation(tokens.Sub)]),
          )
        "*" ->
          lexer_loop(
            new_remaining,
            list.append(tokens, [tokens.Operation(tokens.Mul)]),
          )
        "/" ->
          lexer_loop(
            new_remaining,
            list.append(tokens, [tokens.Operation(tokens.Div)]),
          )
        "!" ->
          lexer_loop(
            new_remaining,
            list.append(tokens, [tokens.Operation(tokens.Fact)]),
          )
        "%" ->
          lexer_loop(
            new_remaining,
            list.append(tokens, [tokens.Operation(tokens.Mod)]),
          )
        "^" ->
          lexer_loop(
            new_remaining,
            list.append(tokens, [tokens.Operation(tokens.Pow)]),
          )
        "v" ->
          lexer_loop(
            new_remaining,
            list.append(tokens, [tokens.Operation(tokens.Tetr)]),
          )

        "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0" -> {
          let number_result =
            string.drop_left(remaining, 1)
            |> parse_number(char)

          case number_result {
            Ok(number) ->
              lexer_loop(
                number.0,
                list.append(tokens, [tokens.Number(number.1)]),
              )

            Error(_) -> Error(Nil)
          }
        }

        " " | "\n" -> lexer_loop(new_remaining, tokens)

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
