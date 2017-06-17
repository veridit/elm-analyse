module Analyser.Checks.DuplicateImportTests exposing (..)

import Analyser.Checks.CheckTestUtil as CTU
import Analyser.Checks.DuplicateImport as DuplicateImport
import Analyser.Messages.Types exposing (..)
import Analyser.Messages.Range as Range
import Test exposing (Test)


goodImports : ( String, String, List MessageData )
goodImports =
    ( "parensBetweenOperators"
    , """module Bar exposing (..)

import Baz
import John
import Jake

foo = 1
"""
    , []
    )


badImports : ( String, String, List MessageData )
badImports =
    ( "parensBetweenOperators"
    , """module Bar exposing (..)

import Baz
import John
import Baz

foo = 1
"""
    , [ DuplicateImport "./foo.elm"
            [ "Baz" ]
            [ Range.manual
                { start = { row = 2, column = 0 }, end = { row = 2, column = 10 } }
                { start = { row = 2, column = -1 }, end = { row = 3, column = -2 } }
            , Range.manual
                { start = { row = 4, column = 0 }, end = { row = 4, column = 10 } }
                { start = { row = 4, column = -1 }, end = { row = 5, column = -2 } }
            ]
      ]
    )


badImportsTripple : ( String, String, List MessageData )
badImportsTripple =
    ( "badImportsTripple"
    , """module Bar exposing (..)

import Baz
import Baz
import Baz

foo = 1
"""
    , [ DuplicateImport "./foo.elm"
            [ "Baz" ]
            [ Range.manual
                { start = { row = 2, column = 0 }, end = { row = 2, column = 10 } }
                { start = { row = 2, column = -1 }, end = { row = 3, column = -2 } }
            , Range.manual
                { start = { row = 3, column = 0 }, end = { row = 3, column = 10 } }
                { start = { row = 3, column = -1 }, end = { row = 4, column = -2 } }
            , Range.manual
                { start = { row = 4, column = 0 }, end = { row = 4, column = 10 } }
                { start = { row = 4, column = -1 }, end = { row = 5, column = -2 } }
            ]
      ]
    )


badImportDouble : ( String, String, List MessageData )
badImportDouble =
    ( "badImportDouble"
    , """module Bar exposing (..)

import Baz
import John
import Baz
import John

foo = 1
"""
    , [ DuplicateImport "./foo.elm"
            [ "Baz" ]
            [ Range.manual
                { start = { row = 2, column = 0 }, end = { row = 2, column = 10 } }
                { start = { row = 2, column = -1 }, end = { row = 3, column = -2 } }
            , Range.manual { start = { row = 4, column = 0 }, end = { row = 4, column = 10 } }
                { start = { row = 4, column = -1 }, end = { row = 5, column = -2 } }
            ]
      , DuplicateImport "./foo.elm"
            [ "John" ]
            [ Range.manual
                { start = { row = 3, column = 0 }, end = { row = 3, column = 11 } }
                { start = { row = 3, column = -1 }, end = { row = 4, column = -2 } }
            , Range.manual
                { start = { row = 5, column = 0 }, end = { row = 5, column = 11 } }
                { start = { row = 5, column = -1 }, end = { row = 6, column = -2 } }
            ]
      ]
    )


all : Test
all =
    CTU.build "Analyser.Checks.DuplicateImportTests"
        DuplicateImport.checker
        [ goodImports
        , badImports
        , badImportsTripple
        , badImportDouble
        ]
