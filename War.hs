module War (deal) where

--import Data.List

{--
Function stub(s) with type signatures for you to fill in are given below. 
Feel free to add as many additional helper functions as you want. 

The tests for these functions can be found in src/TestSuite.hs. 
You are encouraged to add your own tests in addition to those provided.

Run the tester by executing 'cabal test' from the war directory 
(the one containing war.cabal)
--}

-- in replit the test lists were interpreted as Integer.
-- to get around this and keep the type I work with as [Int], I wrote this bit 
integerToInt :: [Integer] -> [Int]
integerToInt = map fromIntegral

-- the replaceOne function replaces all 1s to 14s.
-- This is the first step of the game.
replaceOnes :: [Int] -> [Int]
replaceOnes = map (\x -> if x == 1 then 14 else x)

-- the replaceFourteen is the reverse of the replaceOnes, it replaces all 14s to 1s.
-- This is the last step of the game.
replaceFourteen :: [Int] -> [Int]
replaceFourteen = map (\x -> if x == 14 then 1 else x)

-- this is the second last step of the game, it extracts the non-empty list (winning hand)
extractTupElement :: ([Int], [Int], [Int]) -> [Int]
extractTupElement (([], ys, _)) = replaceFourteen (ys)
extractTupElement ((xs, [], _)) = replaceFourteen (xs)

-- Couldnt use the Data.List.sort function, so I wrote my own.
sortfunc :: [Int] -> [Int]
sortfunc [] = []
sortfunc [x] = [x]
sortfunc (x : xs) = head sorted ++ eq ++ sorted !! 1
  where
    eq = x : [w | w <- xs, w == x]
    lt = [w | w <- xs, w < x]
    gt = [w | w <- xs, w > x]
    sorted = reverse ([sortfunc ws | ws <- [lt, gt]])

-- this is the second step, where the deal (after reversed and replaceOnes), is split into two hands alternatively
alternateSplit :: [Int] -> ([Int], [Int])
alternateSplit [] = ([], [])
alternateSplit [x] = ([x], [])
alternateSplit (x : y : xs) = let (evens, odds) = alternateSplit xs in (x : evens, y : odds)

-- the deal cards game takes 3 arrays, the first and second are the hands each player got,
-- the third array is a placeholder that holds the cards in the situation when both players
-- deal cards of equal value.
pullCardsArr :: ([Int], [Int], [Int]) -> ([Int], [Int])
-- case of empty lists
pullCardsArr ([], ys, []) = ([], ys)
pullCardsArr (xs, [], []) = (xs, [])
pullCardsArr ([], ys, lst) = ([], ys ++ sortfunc lst)
pullCardsArr (xs, [], lst) = (xs ++ sortfunc lst, [])
--------------------
-- case of one element in one of the lists
pullCardsArr ([x], y : y1 : ys, newArr)
  | x < y = pullCardsArr ([], (y1 : ys) ++ sortfunc ([x, y] ++ newArr), [])
  | x > y = pullCardsArr (sortfunc ([x, y] ++ newArr), (y1 : ys), [])
  | otherwise = pullCardsArr ([], y1 : ys ++ sortfunc (newArr ++ [x, y]), [])
pullCardsArr (x : x1 : xs, [y], newArr)
  | x < y = pullCardsArr ((x1 : xs), sortfunc ([x, y] ++ newArr), [])
  | x > y = pullCardsArr ((x1 : xs) ++ sortfunc ([x, y] ++ newArr), [], [])
  | otherwise = pullCardsArr (x1 : xs ++ sortfunc (newArr ++ [x, y]), [], [])
----------------------
-- case of two elements in one of the lists
pullCardsArr ([x, x1], y : y1 : ys, new_arr)
  | x < y = pullCardsArr ([x1], (y1 : ys) ++ sortfunc ([x, y] ++ new_arr), [])
  | x > y = pullCardsArr ([x1] ++ sortfunc ([x, y] ++ new_arr), (y1 : ys), [])
  | otherwise = pullCardsArr ([], ys, sortfunc (new_arr ++ [x, x1, y, y1]))
pullCardsArr (x : x1 : xs, [y, y1], new_arr)
  | x > y = pullCardsArr ((x1 : xs) ++ sortfunc ([x, y] ++ new_arr), [y1], [])
  | x < y = pullCardsArr ((x1 : xs), [y1] ++ sortfunc ([x, y] ++ new_arr), [])
  | otherwise = pullCardsArr (xs, [], sortfunc (new_arr ++ [x, x1, y, y1]))
----------------------
-- case of more than two elements in one of the lists
pullCardsArr (x : x1 : xs, y : y1 : ys, new_arr)
  | x < y = pullCardsArr ((x1 : xs), (y1 : ys) ++ sortfunc ([x, y] ++ new_arr), [])
  | x > y = pullCardsArr ((x1 : xs) ++ sortfunc ([x, y] ++ new_arr), y1 : ys, [])
  | otherwise = pullCardsArr (xs, ys, sortfunc (new_arr ++ [x, y, x1, y1]))
  
deal :: [Int] -> [Int]
deal shuf =
  -- Since Ace == 1, and has the most value, all 1s are replaced with 14s.
  -- Then the list is reversed, before it is split.
  let tup_list = alternateSplit (reverse (replaceOnes (shuf)))
      -- the split list is then pass into pullCardsArr where the game is played.
      result = pullCardsArr (fst tup_list, snd tup_list, [])
   -- when either the fst or second element of the tuple end up empty, the non-empty list is extracted 
   -- as final winning deal.
   in extractTupElement (fst result, snd result, [])

