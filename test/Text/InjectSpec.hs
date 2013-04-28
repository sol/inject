{-# LANGUAGE OverloadedStrings #-}
module Text.InjectSpec (main, spec) where

import           Test.Hspec
import           Test.Hspec.Expectations.Contrib

import           Text.Inject
import           Data.Attoparsec.Text

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "inject" $ do
    it "expands shell commands" $ do
      inject "{{echo foobar}}" `shouldReturn` "foobar\n"

  describe "pBraces (an internal function)" $ do
    it "returns content in between braces" $ do
      parseOnly pBraces "{{foo}bar}}" `shouldBe` Right (Braces "foo}bar")

    it "fails on unterminated braces" $ do
      parseOnly pBraces "{{foo}bar}" `shouldSatisfy` isLeft
