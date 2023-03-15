# CLI Options Parser

A very simplistic CLI args parser. If you're looking for a proper / full-fledged one, check out [elm-cli-options-parser](https://github.com/dillonkearns/elm-cli-options-parser).

## Why does this exist?

Building a full-fledged CLI command parser is one thing but it felt like an overkill for the kind of simple projects I'm doing right now.

Instead, what I want is something as simple as being able to do this:

```bash
> options = "--file ./src/file_path.js --debug"

> getStringValue "file" options
Just "./src/file_path.js"

> getBooleanValue "debug" options
Just True

> getIntValue "count" options
Nothing # indicates --count is not present in the command string
```

## How to use this

- Install `chandru89new/elm-simple-cli-options-parser`

```
~ elm install chandru89new/elm-simple-cli-options-parser
```

- Import and use:

```elm
import CLIOptionsParser exposing (..)

commandString = "--file ./file.js"
file = getStringValue "file" commandString
-- file == Just "./file.js"
```

## Getting different kinds of values out

The library exposes 4 functions to extract different kinds of values.

Take this CLI string:

```
--file ./file.js --debug --count 5 --factor 2.5
```

```bash
> input = "--file ./file.js --debug --count 5 --factor 2.5"

> getStringValue "file" input
Just "./file.js" : Maybe String

> getBooleanValue "debug" input
Just True : Maybe Bool

> getIntValue "count" input
Just 5 : Maybe Int

> getFloatValue "factor" input
Just 2.5 : Maybe Float
```

If you tried to fetch a flag that does not exist, you get `Nothing`:

```bash
> getStringValue "output" input
Nothing : Maybe String
```

You could use the `Nothing` to glean that the user did not pass a flag/option.

## More info

The string can have both keyword args (`--file=somefile.js`) and positional args (`--file somefile.js`).

```bash
> input = "--count=5"

> getIntValue "count" input
Just 5 : Maybe Int

> input = "--count 5"

> getIntValue "count" input
Just 5 : Maybe Int
```

## But wait, why not "-" ?

Short flags / options are cute but can be confusing at times. Is it `-v` or `-V` for version? Does `-h` show help or do something else? Plus, for my needs, `--clarity` trumped everything else.
