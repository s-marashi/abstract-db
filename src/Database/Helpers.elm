module Database.Helpers(doABunch) where

import Task exposing (Task)
import List

import Database as DB

doABunch : DB.Database -> List DB.Action -> Task DB.Error (List DB.Answer)
doABunch db things_to_do =
    Task.sequence (List.map (DB.do db) things_to_do)
