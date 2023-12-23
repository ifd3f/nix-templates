module LibSpec
  ( spec
  ) where

import qualified Lib
import Test.Hspec

spec :: Spec
spec = do
  describe "addThree" $ do
    it "adds three to values" $ do Lib.addThree 12 `shouldBe` 15
