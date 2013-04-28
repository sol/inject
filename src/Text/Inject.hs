{-# LANGUAGE OverloadedStrings, CPP #-}
module Text.Inject (
  inject
#ifdef TEST
, Element (..)
, pBraces
#endif
) where

import           Prelude hiding (takeWhile)
import           Control.Applicative
import           Data.Text (Text)
import qualified Data.Text as T
import           Data.Attoparsec.Text
import           Util

type Template = [Element]

data Element = Plain Text | Braces Text
  deriving (Eq, Show)

inject :: Text -> IO Text
inject = fmap T.concat . mapM f . parseTemplate
  where
    f :: Element -> IO Text
    f element = case element of
      Plain text -> return text
      Braces cmd -> system (T.unpack cmd)

parseTemplate :: Text -> Template
parseTemplate = either parseError id . parseOnly (pTemplate <* endOfInput)
  where
    parseError = (error . unwords) [
        "Parsing failed."
      , "This should never happen"
      , "Please report a bug!"
      ]

pTemplate :: Parser Template
pTemplate = many (pBraces <|> (Plain <$> pText))

pText :: Parser Text
pText = T.cons <$> anyChar <*> takeWhile (/= '{')

pBraces :: Parser Element
pBraces = Braces . T.init <$> ("{{" *> scan 0 f <* "}")
  where
    f 0 '}' = Just 1
    f 1 '}' = Nothing
    f _ _   = Just (0 :: Int)
