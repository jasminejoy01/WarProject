module War (deal) where

import Data.List

{--
Function stub(s) with type signatures for you to fill in are given below. 
Feel free to add as many additional helper functions as you want. 

The tests for these functions can be found in src/TestSuite.hs. 
You are encouraged to add your own tests in addition to those provided.

Run the tester by executing 'cabal test' from the war directory 
(the one containing war.cabal)
--}

sort :: [Integer] -> [Integer]
sort [] = []
sort [x] = [x]
sort (x : xs) = sorted !! 0 ++ eq ++ sorted !! 1
  where
    eq = x : [w | w <- xs, w == x]
    lt = [w | w <- xs, w < x]
    gt = [w | w <- xs, w > x]
    sorted = [sort ws | ws <- [lt, gt]]

alternateSplit :: [Integer] -> ([Integer], [Integer])
alternateSplit [] = ([], [])
alternateSplit [x] = ([x], [])
alternateSplit (x : y : xs) = let (odds, evens) = alternateSplit xs in (x : odds, y : evens)

dropHead :: [Integer] -> [Integer]
dropHead [] = []
dropHead (_ : xs) = xs

skipPull :: ([Integer], [Integer]) -> ([Integer], [Integer])
skipPull ([], []) = ([], [])
skipPull ([], ys) = ([], ys)
skipPull (xs, []) = (xs, [])
skipPull (x : xs, y : ys)
  | head xs < head ys = pullCards (tail xs, tail ys ++ reverse (sort [x, y, head xs, head ys]))
  | head xs > head ys = pullCards (tail xs ++ reverse (sort [x, y, head xs, head ys]), tail ys)
  | otherwise = skipPull (tail xs, tail ys)
skipPull ([x], [y])
  | x < y = ([], [x, y])
  | x > y = ([x, y], [])
  | otherwise = ([], [])

pullCards :: ([Integer], [Integer]) -> ([Integer], [Integer])
pullCards ([], []) = ([], [])
pullCards ([], ys) = ([], ys)
pullCards (xs, []) = (xs, [])
pullCards ([x], [y])
  | x < y = ([], [x, y])
  | x > y = ([x, y], [])
  | otherwise = ([], [])
pullCards ((x : x1 : xs), (y : y1 : ys))
  | x == y = skipPull (xs, ys)
  | x < y = pullCards (x1 : xs, ys ++ reverse (sort [x, y]))
  | x > y = pullCards (x1 : xs ++ reverse (sort [x, y]), y1 : ys)
  | otherwise = ([], [])
	
deal :: [Int] -> [Int]
deal shuf = pullCards (alteranateSplit shuf)
               
    
