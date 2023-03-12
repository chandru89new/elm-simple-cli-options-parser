module Tests exposing (..)

import Dict
import Expect
import OptionsDecoder exposing (getBoolean, getValue, parseString)
import Test exposing (..)


tests : Test
tests =
    describe "all tests"
        [ test "parse --file ./some/file/path.js" <|
            \_ ->
                let
                    str =
                        "--file ./some/file/path.js"
                in
                str
                    |> parseString
                    |> getValue "file"
                    |> Expect.equal (Just "./some/file/path.js")
        , test "parse --file ./some/file/path.js --error" <|
            \_ ->
                let
                    str =
                        "--file ./some/file/path.js --error"

                    parsed =
                        parseString str

                    file =
                        getValue "file" parsed

                    error =
                        getBoolean "error" parsed

                    result =
                        ( file, error )
                in
                result
                    |> Expect.equal ( Just "./some/file/path.js", Just True )
        , test "parse --file=./some/file/path.js --debug --option something" <|
            \_ ->
                let
                    str =
                        "--file=./some/file/path.js --debug --option something"

                    parsed =
                        parseString str

                    expectedOutput =
                        Dict.fromList
                            [ ( "debug", OptionsDecoder.Boolean True )
                            , ( "file", OptionsDecoder.Str "./some/file/path.js" )
                            , ( "option", OptionsDecoder.Str "something" )
                            ]
                in
                parsed
                    |> Expect.equal expectedOutput
        ]
