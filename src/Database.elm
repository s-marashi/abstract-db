module Database(Database, Error, Answer(..), open, close, Action(..), do) where

import Task exposing (Task, andThen, succeed)
import TaskTutorial exposing (print)

type Database =
    Database

type Error =
    Error String

type Answer =
    Answer String | Done

open : String -> Task Error Database
open location =
    print ( "Open: " ++ location ) 
    `andThen` (\_ -> succeed Database)

close : Database -> Task Error Answer
close db =
    print "Close" `andThen` \_ -> succeed Done

-- These actions are implementation specific
type Action =
      Nothing
    | Put String String
    | Get String
    | Del String

dbPut : Database -> String -> String -> Task Error Answer
dbPut db key value =
    print ( "Put: " ++ key ++ " = " ++ value ) 
    `andThen` \_ -> succeed (Done)

dbGet : Database -> String -> Task Error Answer
dbGet db key =
    print ( "Get: " ++ key ) 
    `andThen` \_ -> succeed (Answer key)

dbDel : Database -> String -> Task Error Answer
dbDel db key =
    print ( "Del: " ++ key )
    `andThen` \_ -> succeed Done

do : Database -> Action -> Task Error Answer
do db action =
    case action of
        Nothing ->
            succeed Done

        Put key value ->
            dbPut db key value

        Get key ->
            dbGet db key

        Del key ->
            dbDel db key
