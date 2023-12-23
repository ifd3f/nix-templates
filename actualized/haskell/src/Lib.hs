module Lib where

import HaskellSay (haskellSay)

main :: IO ()
main = haskellSay "Hello Haskell Nixers!"

addThree :: Int -> Int
addThree = (+ 3)
