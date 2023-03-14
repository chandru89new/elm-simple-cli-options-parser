module Tests exposing (..)

import Dict
import Expect
import OptionsDecoder exposing (OptionValue(..), getValue, parseString)
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
                    |> Expect.equal (Str "./some/file/path.js")
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
                        getValue "error" parsed

                    nonExistentFlag =
                        getValue "non-existent" parsed

                    result =
                        ( file, error, nonExistentFlag )
                in
                result
                    |> Expect.equal ( Str "./some/file/path.js", Boolean True, DoesNotExist )
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


examples : Test
examples =
    describe "test of examples"
        [ test "--file=file_path.js --debug --log_file=logs.txt" <|
            \_ ->
                let
                    input =
                        "--file=file_path.js --debug --log_file=logs.txt"

                    output =
                        Dict.fromList [ ( "debug", Boolean True ), ( "file", Str "file_path.js" ), ( "log_file", Str "logs.txt" ) ]
                in
                input
                    |> parseString
                    |> Expect.equal output
        , test "--file file_path.js --flag --count 5" <|
            \_ ->
                let
                    input =
                        "--file file_path.js --flag --count 5"

                    output =
                        Dict.fromList [ ( "count", Str "5" ), ( "file", Str "file_path.js" ), ( "flag", Boolean True ) ]
                in
                input
                    |> parseString
                    |> Expect.equal output
        , test "--file file_path.js --flag --count 5 |> get value of file" <|
            \_ ->
                let
                    result =
                        parseString "--file file_path.js --flag --count 5" |> getValue "file"
                in
                result
                    |> Expect.equal (Str "file_path.js")
        , test "--file file_path.js --flag --count 5 |> get value of count" <|
            \_ ->
                let
                    result =
                        parseString "--file file_path.js --flag --count 5" |> getValue "count"
                in
                result
                    |> Expect.equal (Str "5")
        , test "--file file_path.js --flag --count 5 |> getValue of flag" <|
            \_ -> parseString "--file file_path.js --flag --count 5" |> getValue "flag" |> Expect.equal (Boolean True)
        , test "--file file_path.js --flag --count 5 |> getValue of non-existent" <|
            \_ -> parseString "--file file_path.js --flag --count 5" |> getValue "non-existent" |> Expect.equal DoesNotExist
        ]
