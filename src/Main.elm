module Main exposing (..)

import Browser
import Html exposing (Html, input, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

main =
  Browser.sandbox { init = init, update = update, view = view }

-- Model
type alias Model = 
    { name: String
    , password: String
    , repeat: String
    }

init : Model
init =
    Model "" "" ""

-- Controller
type Msg 
    = Name String
    | Password String
    | Repeat String


update : Msg -> Model -> Model
update msg model = 
    case msg of 
        Name name -> 
            { model | name = name }
        
        Password password -> 
            { model | password = password }

        Repeat repeat -> 
            { model | repeat = repeat }


-- View
view : Model -> Html Msg

view model = 
    div []
        [ viewInput "text" "Name" model.name Name 
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Repeat" model.repeat Repeat
        , viewValidation model
        ]

viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput typ placeholdr val toMsg =
    input [ type_ typ, placeholder placeholdr, value val, onInput toMsg ] []

viewValidation : Model -> Html msg
viewValidation model = 
    if model.password == model.repeat then
        div [ style "color" "green" ] [ text "OK" ]
    else 
        div [ style "color" "red" ] [ text "Passwords do not match!" ]

