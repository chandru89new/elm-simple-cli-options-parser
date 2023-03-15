module CLIOptionsParser exposing (getStringValue, getBooleanValue, getIntValue, getFloatValue)

{-| A very simplistic CLI args parser. If you're looking for a proper / full-fledged one, check out [elm-cli-options-parser](https://github.com/dillonkearns/elm-cli-options-parser).


# Usage

@docs getStringValue, getBooleanValue, getIntValue, getFloatValue

-}

import Dict exposing (Dict)


isOption : String -> Bool
isOption =
    String.startsWith "--"


splitBy : (String -> Bool) -> String -> List String
splitBy fn str =
    let
        split_ =
            String.split "" str

        splitByHelper checker xs state final =
            case xs of
                [] ->
                    List.reverse (state :: final)

                x :: rest ->
                    if checker x then
                        splitByHelper checker rest "" (state :: final)

                    else
                        splitByHelper checker rest (state ++ x) final
    in
    splitByHelper fn split_ "" []


type OptionValue
    = Str String
    | Boolean Bool
    | Integer Int
    | F Float


type alias Options =
    Dict String OptionValue


parsePair : ( String, String ) -> Options -> Options
parsePair ( fst, snd ) dict =
    let
        parseValue : String -> OptionValue
        parseValue string =
            case ( String.toFloat string, String.toInt string ) of
                ( _, Just v ) ->
                    Integer v

                ( Just v, _ ) ->
                    F v

                _ ->
                    Str string
    in
    if not (isOption fst) then
        dict

    else if not (isOption snd) then
        Dict.insert (String.replace "--" "" fst) (parseValue snd) dict

    else
        Dict.insert (String.replace "--" "" fst) (Boolean True) dict


parseList : List String -> Options -> Options
parseList xs opts =
    case xs of
        f :: s :: rest ->
            parseList (s :: rest) (parsePair ( f, s ) opts)

        s :: [] ->
            parsePair ( s, "--dummy" ) opts

        [] ->
            opts


parseString : String -> Options
parseString str =
    parseList (splitBy spaceOrEqual str) Dict.empty


spaceOrEqual : String -> Bool
spaceOrEqual =
    \s -> s == " " || s == "="


{-| Get the value of a CLI option/argument which you expect to be a string:

    getStringValue "file" "--file ./file_path.js" == Just "./file_path.js"

    getStringValue "output" "--file ./file_path.js" == Nothing

-}
getStringValue : String -> String -> Maybe String
getStringValue key cliStr =
    Dict.get key (parseString cliStr)
        |> Maybe.andThen
            (\opt ->
                case opt of
                    Str v ->
                        Just v

                    _ ->
                        Nothing
            )


{-| Get the value of a CLI option/argument which you expect to be just a flag without any value associated with it:

    getBooleanValue "debug" "--debug" == Just True

    getBooleanValue "debug" "--debug=true" == Nothing

    getBooleanValue "debug" "--enabled" == Nothing

-}
getBooleanValue : String -> String -> Maybe Bool
getBooleanValue key cli =
    Dict.get key (parseString cli)
        |> Maybe.andThen
            (\opt ->
                case opt of
                    Boolean v ->
                        Just v

                    _ ->
                        Nothing
            )


{-| Get the value of a CLI option/argument which you expect to be an integer:

    getIntValue "count" "--count=5" == Just 5

    getIntValue "count" "--count 5" == Just 5

    getIntValue "count" "--file ./file_path.js" == Nothing

-}
getIntValue : String -> String -> Maybe Int
getIntValue key cli =
    Dict.get key (parseString cli)
        |> Maybe.andThen
            (\opt ->
                case opt of
                    Integer v ->
                        Just v

                    _ ->
                        Nothing
            )


{-| Get the value of a CLI option/argument which you expect to be an integer:

    getFloatValue "factor" "--factor=5.5" == Just 5.5

    getFloatValue "factor" "--factor 5.5" == Just 5.5

    getFloatValue "factor" "--file ./file_path.js" == Nothing

-}
getFloatValue : String -> String -> Maybe Float
getFloatValue key cli =
    Dict.get key (parseString cli)
        |> Maybe.andThen
            (\opt ->
                case opt of
                    F v ->
                        Just v

                    _ ->
                        Nothing
            )
