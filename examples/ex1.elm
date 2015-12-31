import Graphics.Element exposing (show)
import Task exposing (Task, andThen, succeed)

import Database as DB


main =
    show "Write Some mock data to database Open your console to see results"

port mocker : Task DB.Error DB.Answer
port mocker =
    DB.open "mydb"
    `andThen` \db -> DB.do db (DB.Put "Name" "Sadegh")
    `andThen` \_  -> DB.do db (DB.Get "Name")
    `andThen` \_  -> DB.do db (DB.Del "Name")
    `andThen` \_  -> DB.close db
