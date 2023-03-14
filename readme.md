# CLI Options Decoder

A very simplistic CLI args decoder. If you're looking for a proper / full-fledged one, check out [elm-cli-options-parser](https://github.com/dillonkearns/elm-cli-options-parser).

This is not a package. To use this, you'll have to copy the `src/OptionsDecoder.elm` into your project or run it via `elm repl`.

## To init

```
# Install elm globally so you can run elm-repl
npm i -g elm
```

## To run

We'll use `elm repl` as a way to run this code:

Get started by this:

```
$ elm repl
elm> import OptionsDecoder exposing (..)
```

Then, test a string:

```elm
elm> parseString "--file=file_path.js --debug --log_file=logs.txt"
Dict.fromList [("debug",Boolean True),("file",Str "file_path.js"),("log_file",Str "logs.txt")]

elm> parseString "--file file_path.js --flag --count 5"
Dict.fromList [("count",Str "5"),("file",Str "file_path.js"),("flag",Boolean True)]
```

Everything that looks like a flag/option (ie anything starting with `--`) will get parsed into one of these two things:

```elm
Str String | Bool Boolean
```

The string can have both keyword args (`--file=somefile.js`) and positional args (`--file somefile.js`).

**To extract the values**:

Use `getValue` to extract the value of a flag. If the flag is not in the string, you will get a `DoesNotExist` value.

```elm
elm> parseString "--file file_path.js --flag --count 5" |> getValue "file"
Str "file_path.js"

elm> parseString "--file file_path.js --flag --count 5" |> getValue "count"
Str "5"

elm> parseString "--file file_path.js --flag --count 5" |> getValue "flag"
Boolean True

elm> parseString "--file file_path.js --flag --count 5" |> getValue "non-existent"
DoesNotExist
```

## But wait, why not "-" ?

Short flags / options are cute but can be confusing at times. Is it `-v` or `-V` for version? Does `-h` show help or do something else? Plus, for my needs, `--clarity` trumped everything else.
