module Util where

import qualified Control.Exception as E
import           System.Process
import           System.IO (hClose)
import           System.Exit
import           Data.Text
import           Data.Text.IO


system :: String -> IO Text
system cmd = E.mask $ \restore -> do
  (Nothing, Just h, Nothing, pid) <- createProcess (shell cmd) {std_out = CreatePipe}
  restore $ do
    output <- hGetContents h
    waitForProcess pid >>= \r -> case r of
      ExitSuccess -> return output
      ExitFailure c ->
        (E.throwIO . userError) ("system: " ++ cmd ++ " (exit " ++ show c ++ ")")
    `E.onException` do
      hClose h
      terminateProcess pid
      waitForProcess pid
