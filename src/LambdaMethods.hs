module Main where

import Semantica
import GramaticaConcreta
import GramaticaAbstracta
import EcuacionesNoLineales
import UU.Parsing
import Graphics.UI.Gtk
import Graphics.UI.Gtk.Glade
import Prelude
import Control.Exception
import Foreign

process ::(EntryClass e) => String -> e -> String -> String -> String -> IO ()
process s e a1 b p   
              | (p == "ver ecuacion parser") = do a <- parseIO pFunc (funScanTxt s)
                                                  let st = show a
                                                  set e [ entryText := show st ]
              | (p == "Busqueda incremental") = do f <- parseIO pFunc (funScanTxt s)
                                                   b <- parseIO pFunc (funScanTxt b)
                                                   a1 <-parseIO pFunc (funScanTxt a1)
                                                   let st = busqdIncremental f a1 b 10
                                                   set e [entryText := show st]
              | otherwise = set e [entryText := "todavia no"]


{- Funcion que me retorna el texto utilizado como control en el process-}
control :: RadioButton -> String
control b =  unsafePerformIO(get b buttonLabel)

{-Funcion que me retorna el radiobutton activo-}
controlRadio :: [RadioButton] -> RadioButton
controlRadio ar = head (filter (\x -> unsafePerformIO(toggleButtonGetActive x)) ar)   
      
{-Funcion que va indicando en la consola el cambio de estado de los radiobutton -}
setRadioState :: RadioButton -> IO ()
setRadioState b = do
  state <- toggleButtonGetActive b
  label <- get b buttonLabel
  putStrLn ("State " ++ label ++ " now is " ++ (show state))  
            
{-Funcion Principal para la creacion de la interfaz del proyecto-}
main = do
  initGUI
  ventana     <- windowNew
  set ventana [windowTitle := "LambdaMethods",
              containerBorderWidth := 5,  windowDefaultWidth := 300,
              windowDefaultHeight := 400 ]
  table   <- tableNew 2 2 True
  containerAdd ventana table

  content <- vBoxNew False 0
  tableAttachDefaults table content 0 1 0 1
  entrada <- entryNew
  boxPackStart content entrada PackNatural 5
  salida  <- entryNew
  boxPackStart content salida PackNatural 5
  eval <- buttonNewWithLabel "Evaluar"
  boxPackStart content eval  PackNatural 0
  graficar <- buttonNewWithLabel "Evaluar"
  boxPackStart content graficar  PackNatural 0
  
  
  show  <- vBoxNew False 0
  tableAttachDefaults table show 0 1 1 2
  radio1 <- radioButtonNewWithLabel "ver ecuacion parser"
  boxPackStart show radio1 PackNatural 0

  busqdInc <- hBoxNew False 0 
  tableAttachDefaults table busqdInc 0 1 1 2
  radio2 <- radioButtonNewWithLabelFromWidget radio1 "Busqueda incremental"
  boxPackStart busqdInc radio2 PackNatural 0
  a <- entryNew
  boxPackStart busqdInc a PackNatural 0
  b <- entryNew 
  boxPackStart busqdInc b PackNatural 0
  
  toggleButtonSetActive radio1 True
  onToggled radio1 (setRadioState radio1)
  onToggled radio2 (setRadioState radio2)
  onClicked eval $ do
        texto <- get entrada entryText
        a <- get a entryText
        b <- get b entryText
        process texto salida a b (control(controlRadio [radio1,radio2]))

  -- onEntryActivate entrada $ do
  --       texto <- get entrada entryText
  --       a <- get a entryText
  --       b <- get b entryText
  --       process texto salida a b (control(head(controlRadio [radio1,radio2])))
  onDestroy ventana mainQuit
  widgetShowAll ventana
  mainGUI
   
  

 
  