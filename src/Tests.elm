module Tests exposing (..)

import CLIOptionsParser exposing (getBooleanValue, getFloatValue, getIntValue, getStringValue)
import Expect
import Test exposing (..)


tests : Test
tests =
    describe "all tests"
        [ test "--file ./src/file_path.js --debug" <|
            \_ ->
                let
                    input =
                        "--file ./src/file_path.js --debug"

                    output =
                        ( getStringValue "file" input, getBooleanValue "debug" input, getIntValue "count" input )
                in
                Expect.equal output ( Just "./src/file_path.js", Just True, Nothing )
        , test "--file ./file.js" <|
            \_ ->
                let
                    input =
                        "--file ./file.js"

                    output =
                        getStringValue "file" input
                in
                Expect.equal output (Just "./file.js")
        , test "--file ./file.js --debug --count 5 --factor 2.5" <|
            \_ ->
                let
                    input =
                        "--file ./file.js --debug --count 5 --factor 2.5"

                    output =
                        { file = getStringValue "file" input
                        , debug = getBooleanValue "debug" input
                        , count = getIntValue "count" input
                        , factor = getFloatValue "factor" input
                        , notThere = getStringValue "output" input
                        }
                in
                Expect.equal output { file = Just "./file.js", debug = Just True, count = Just 5, factor = Just 2.5, notThere = Nothing }
        , test "--count=5" <|
            \_ ->
                ("--count=5" |> getIntValue "count")
                    |> Expect.equal (Just 5)
        , test "--count 5" <|
            \_ ->
                ("--count 5" |> getIntValue "count")
                    |> Expect.equal (Just 5)
        ]
