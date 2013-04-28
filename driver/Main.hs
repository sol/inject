module Main (main) where

import qualified Data.Text.IO as T

import Text.Inject

main :: IO ()
main = T.getContents >>= inject >>= T.putStr
