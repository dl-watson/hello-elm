module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)

-- Main

main = 
    Browser.element 
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

-- Model 

type Model 
    = Failure
    | Loading
    | Success String

-- init starts us out in the Loading state, with a command to get a random gif
init : () -> (Model, Cmd Msg)
init _ = 
    (Loading, getRandomGif)

-- Update

type Msg
    = MorePlease 
    | GotGif (Result Http.Error String)

-- update handles the GotGif message for whenever a new gif is available
-- it also handles the MorePlease message when someone presses the button
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        MorePlease ->
            (Loading, getRandomGif)
        
        GotGif result ->
            case result of 
                Ok url ->
                    (Success url, Cmd.none)
                
                Err _ -> 
                    (Failure, Cmd.none)

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- View

-- view shows us the cats, depending on the state of our model
view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "random cats"]
        , viewGif model
        ]

-- clicking MorePlease triggers the getRandomGif func, which sends a GotGif message to the update resolver, which resolves to either Ok (Model -> Success) or Err (Model -> Failure) as above in the update func
viewGif : Model -> Html Msg
viewGif model = 
    case model of 
        Failure -> 
            div []
                [ text "i couldn't find a random cat :("
                , button [ onClick MorePlease ] [ text "try again!" ]
                ]
            
        Loading ->
            text "loading..."

        Success url ->
            div []
                [ button [ onClick MorePlease, style "display" "block" ] [ text "more please!" ]
                , img [ src url ] []
                ]

getRandomGif : Cmd Msg
getRandomGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
        , expect = Http.expectJson GotGif gifDecoder
        }

gifDecoder : Decoder String
gifDecoder =
    field "data" (field "image_url" string)