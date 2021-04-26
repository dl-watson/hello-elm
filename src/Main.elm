module Main exposing (..)

import Browser
import Html exposing (Html, input, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Debug exposing (toString)

main =
  Browser.sandbox { init = init, update = update, view = view }

-- Model
type alias Model = 
    { placehlder : String 
    , name : String
    }

init : Model
init =
    { placehlder = ""
    , name = "dee"
    }

-- Controller
type Msg 
    = Change String


update : Msg -> Model -> Model
update msg model = 
    case msg of 
        Change content -> 
            { model | placehlder = content }


-- View
view : Model -> Html Msg

view model = 
    div [] 
        [ input [ placeholder "text to reverse", value model.placehlder, onInput Change ] []
        , div [] [ text (String.reverse model.placehlder) ]
        , div [] [ text model.name ]
    ]
