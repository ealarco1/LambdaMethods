module InterfazGrafica

import AP.GUI
import Monad

main :: IO ()
main = gui prog
  where
    prog = do { w   <- window [ title =: "RadioButton demo" 
                              , on windowClose =: quit
                              ]

              ; l <- label [] w

              ; let mkRB txt = 
                     do { im <- loadImageFrom ("images/a"++txt++".gif")
                        ; rb <- radioButton [ text =: txt
                                            , on action =: do { l!:photo =: im }
                                            ] w
                        ; return (rb,im)
                        }

              ; (rbs,ims) <- mapAndUnzipM mkRB ["Dog", "Cat", "Bird"]
                
              ; rg <- radioGroup [ radioButtons =: rbs ]

              ; let initSel = 0
              ; l !: photo =: ims !! initSel
              ; (rbs!!initSel) !: checked =: True
                                 
              ; f <- frame [ layout =: vertical rbs
                           , relief =: Groove
                           ] w

              ; q   <- button [ text =: "Quit" 
                              , on action =: quit
                              ] w
              ; w!:layout =:  pad 10 f <.< pad 10 l ^.^ q
              }
