import Graphics.Element exposing (show, Element)
import Task exposing (Task, andThen, succeed, sequence, map)
import Signal exposing (Mailbox, mailbox, send)
import Debug

import Database as DB
import Database.Helpers exposing (..)

main : Signal Element
main =
    Signal.map2 (\done results -> 
            show
            <| "Finished: " ++ (toString done) ++  " , " ++ (toString  results))
        tasksDone.signal tasksResult.signal

tasksDone : Mailbox Bool
tasksDone =
    mailbox False

tasksResult : Mailbox (List DB.Answer)
tasksResult =
    mailbox []

database : Mailbox (Maybe DB.Database)
database =
    mailbox Nothing

things_to_put : List DB.Action
things_to_put =
    [
      DB.Put "Name" "Sadegh",
      DB.Put "SureName" "Marashi",
      DB.Put "Field" "Mechanical Engineering",
      DB.Put "City" "Mashhad",
      DB.Get "City",
      DB.Del "Field"
    ]

port mocking : Task DB.Error ()
port mocking =
    DB.open "mydb"
    -- Store Database for future uses
    `andThen` \db -> send database.address (Just db)
    -- Do a bunch of database actions
    `andThen` \_  -> doABunch db things_to_put
    -- Store Results
    `andThen` \results -> send tasksResult.address results
    -- Say : "Hey we are done"
    `andThen` \_   -> send tasksDone.address True

port closeIt : Signal (Task DB.Error ())
port closeIt =
    let
        taskGenerator db done =
            case db of
                Just db ->
                    if done == True then
                        DB.close db `andThen` \_ -> succeed ()
                    else
                        succeed ()

                Nothing ->
                    if done == False then
                        succeed ()
                    else
                        Debug.crash "It is impossible"
    in
        Signal.map2 taskGenerator database.signal tasksDone.signal
