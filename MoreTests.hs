module Main where

import qualified GRAMMAR.Lex as U
import qualified GRAMMAR.Par as U
import qualified GRAMMAR.Abs as U
import qualified GRAMMAR.Print as U
import GRAMMAR.ErrM

import Control.Applicative
import Control.Monad
import System.IO (stderr, hPutStrLn)
import System.Environment (getArgs)
import Test.HUnit

parse s = U.pProgram (U.myLexer s)

parseResult :: String -> IO U.Program
parseResult s = case parse s of
                  Ok prog -> return prog
                  Bad err ->
                    error ("Error in " ++ s ++ ":\n<<<<<<<<<<<<<<<<<<<<<<\n" ++
                           err ++ "\n>>>>>>>>>>>>>>>>>>>>>>")

sameAST :: String -> String -> Test
sameAST s1 s2 = TestCase $ do
  prog1 <- parseResult s1
  prog2 <- parseResult s2
  assertBool (s1 ++ "\n" ++ show prog1 ++ "\n~/=\n" ++ s2 ++ "\n" ++ show prog2)
    (prog1 == prog2)

expInMain :: String -> String
expInMain s = "int main() { " ++ s ++ "; }"

sameExpAST e1 e2 = sameAST (expInMain e1) (expInMain e2)

isBad (Ok _) = False
isBad (Bad _) = True

isGood = not . isBad

shouldReject :: String -> String -> Test
shouldReject msg s = TestCase $ do
  let res = parse s
  assertBool (msg ++ ": Program `" ++ s ++ "` should be rejected by the parser.\n") (isBad res)


shouldAccept :: String -> String -> Test
shouldAccept msg s = TestCase $ do
  let res = parse s
  assertBool (msg ++ ": Program `" ++ s ++ "` should be accepted by the parser.\n") (isGood res)

shouldRejectExp :: String -> String -> Test
shouldRejectExp msg e = shouldReject msg $ expInMain e

shouldAcceptExp :: String -> String -> Test
shouldAcceptExp msg e = shouldAccept msg $ expInMain e

tests :: Test
tests =
  TestList [
           -- Basic assoc tests
             sameExpAST "e1 * e2 * e3" "(e1 * e2) * e3"
           , sameExpAST "e1 / e2 / e3" "(e1 / e2) / e3"

           , sameExpAST "e1 * e2 / e3" "(e1 * e2) / e3"
           , sameExpAST "e1 / e2 * e3" "(e1 / e2) * e3"

           , sameExpAST "e1 + e2 + e3" "(e1 + e2) + e3"
           , sameExpAST "e1 - e2 - e3" "(e1 - e2) - e3"

           , sameExpAST "e1 + e2 - e3" "(e1 + e2) - e3"
           , sameExpAST "e1 - e2 + e3" "(e1 - e2) + e3"

           , sameExpAST "e1 && e2 && e3" "(e1 && e2) && e3"
           , sameExpAST "e1 || e2 || e3" "(e1 || e2) || e3"

           , sameExpAST "e1 = e2 = e3" "e1 = (e2 = e3)"

           -- More involved tests
           , sameExpAST "++x * y" "(++x) * y"
           , sameExpAST "++x / y" "(++x) / y"
           , sameExpAST "--x * y" "(--x) * y"
           , sameExpAST "--x / y" "(--x) / y"

           , sameExpAST "i + x * 5" "i + (x * 5)"
           , sameExpAST "i + x / 5" "i + (x / 5)"
           , sameExpAST "i - x * 5" "i - (x * 5)"
           , sameExpAST "i - x / 5" "i - (x / 5)"
           , sameExpAST "x * 5 + i" "(x * 5) + i"
           , sameExpAST "x * 5 - i" "(x * 5) - i"
           , sameExpAST "x / 5 + i" "(x / 5) + i"
           , sameExpAST "x / 5 - i" "(x / 5) - i"

           , sameExpAST "x || y && z" "x || (y && z)"
           , sameExpAST "x && y || z" "(x && y) || z"

           , sameExpAST "x == y && z" "(x == y) && z"
           , sameExpAST "x == y || z" "(x == y) || z"
           , sameExpAST "x && y == z" "x && (y == z)"
           , sameExpAST "x || y == z" "x || (y == z)"
           , sameExpAST "x != y && z" "(x != y) && z"
           , sameExpAST "x != y || z" "(x != y) || z"
           , sameExpAST "x && y != z" "x && (y != z)"
           , sameExpAST "x || y != z" "x || (y != z)"

           -- Duplicate
           , sameExpAST "a + b + c" "(a + b) + c"

           , sameExpAST "a && b || c && e > 9" "(a && b) || (c && (e > 9))"

           , sameExpAST "a = b || c" "a = (b || c)"

           -- Duplicate
           , sameExpAST "x = y = z" "x = (y = z)"

           -- , shouldAcceptExp
           --     "Conditional as parentheses around assignment"
           --     "true ? x = false : false"


           -- , shouldReject "Multiple expressions when indexing"
           --   "int main() { x[1, 2]; }"

           , shouldAcceptExp "mult applied to bool"       "true * false"
           , shouldAcceptExp "div applied to bool"        "true / false"
           , shouldAcceptExp "add applied to bool"        "true + false"
           , shouldAcceptExp "sub applied to bool"        "true - false"
           , shouldAcceptExp "lt applied to bool"         "true < false"
           , shouldAcceptExp "gt applied to bool"         "true > false"
           , shouldAcceptExp "ge applied to bool"         "true >= false"
           , shouldAcceptExp "le applied to bool"         "true <= false"
           , shouldAcceptExp "conjunction applied to int" "1 && 0"
           , shouldAcceptExp "disjunction applied to int" "1 || 0"
           ]

main = runTestTT tests
{-
instance Enumerable Id where
  enumerate = consts [ nullary $ Id "a"
                     , nullary $ Id "b"
                     , nullary $ Id "c" ]

c1 f = fmap f shared

c2 f = c1 (funcurry f)

instance Enumerable Type where
  enumerate = consts $ map (fmap TNoRef) base ++ map (fmap TRef) base
    where base =  [ nullary Type1_bool
                  , nullary Type1_int
                  , nullary Type1_void
                  , nullary Type1_double
                  , unary TQConst
                  ]

sanitizeChar :: Char -> Char
sanitizeChar x | x >= 'a' && x <= 'z' = x
               | otherwise = 'x'

fmap concat $ mapM deriveEnumerable'
       [ dExcept 'NameTempl [| c2 $ \x -> NameTempl x . nonEmpty |] $
           dAll ''Name
       , dAll ''QConst
       , dExcept 'EChar [| c1 $ EChar . sanitizeChar |] $
         dAll ''Exp
       ]
-}
