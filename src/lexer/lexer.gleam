import gleam/list
import gleam/string
import gleam/float

// import lexer/tokens

pub type Token {
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

pub fn lexer(input: String) -> Result(List(Token), Nil) {
  lexer_loop(input, [])
}

fn lexer_loop(
  remaining: String,
  tokens: List(Token),
) -> Result(List(Token), Nil) {
  let new_remaining = string.drop_left(remaining, 1)

  case string.first(remaining) {
    Error(_) -> Error(Nil)

    Ok(char) -> {
      case char {
        "(" -> lexer_loop(new_remaining, list.append(tokens, [OpenBracket]))
        ")" -> lexer_loop(new_remaining, list.append(tokens, [CloseBracket]))
        "+" -> lexer_loop(new_remaining, list.append(tokens, [Operation(Add)]))
        "-" -> lexer_loop(new_remaining, list.append(tokens, [Operation(Sub)]))
        "*" -> lexer_loop(new_remaining, list.append(tokens, [Operation(Mul)]))
        "/" -> lexer_loop(new_remaining, list.append(tokens, [Operation(Div)]))
        "!" -> lexer_loop(new_remaining, list.append(tokens, [Operation(Fact)]))
        "%" -> lexer_loop(new_remaining, list.append(tokens, [Operation(Mod)]))
        "^" -> lexer_loop(new_remaining, list.append(tokens, [Operation(Pow)]))
        "v" -> lexer_loop(new_remaining, list.append(tokens, [Operation(Tetr)]))

        // "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0" -> {
        //   lexer_loop()
        // }
        _ -> Error(Nil)
      }
    }
  }
}

// fn parse_number(remaining: String, number_til_now: String) -> #(String, Float) {
//   case string.first(remaining) {
//     Error(Nil) -> 
//     "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0" | "." | "," -> {
//       todo
//     }
//   }
// }

fn check_number(remaining_number: String, is_first: Bool) -> Result(Float, Nil) {
  case string.first(remaining_number) {
    Ok(char) -> {
      case char {
        "." -> {
          case is_first {
            True -> Error(Nil)
            False -> 
          }
        }
      }
    }
    Error(Nil) -> float.parse(remaining_number)
  }
}
