module Stage where

import Node
import NodeList
import DataPoint
import Data.List

data Stage a = Stage [(NodeList a)]

newStageFromData :: DataPoint a => Show a => [a] -> Stage a
newStageFromData ds = Stage $ map (\d -> NodeList [(Node d)]) ds

nextStage :: DataPoint a => Stage a -> Stage a
nextStage (Stage lst)
  | length lst == 1 = Stage lst
  | otherwise = Stage ((mergeTwoNodeLists (fst bestCouple) (snd bestCouple)):bestRest)
  where (bestCouple, bestRest) = bestTuple (Stage lst)

bestTuple :: DataPoint a => Stage a -> (((NodeList a), (NodeList a)), [(NodeList a)])
bestTuple (Stage lst) = head $ sortOn (\((nodeList1, nodeList2), rest) -> distance nodeList1 nodeList2) $ pickCouples lst

bestDistance :: DataPoint a => Stage a -> Float
bestDistance stage
  | (stageNodeListLength stage) == 1 = 0
  | otherwise = distance nodeList1 nodeList2
  where ((nodeList1, nodeList2), bestRest) = bestTuple stage
        stageNodeListLength (Stage lst) = length lst

pickCouples :: [a] -> [((a, a), [a])]
pickCouples lst = map (\(i, j) -> (((lst !! i), (lst !! j)), (removeTwo lst i j))) [(i, j) | i <- [0..((length lst) - 2)], j <- [i+1..((length lst) - 1)]]
  where removeTwo l i j = remove (remove l i) (j - 1) -- (j - 1) because once i is removed indices drop by 1
        remove l i = (take i l) ++ (drop (i + 1) l)

pickSingles :: [a] -> [(a, [a])]
pickSingles lst = map (\i -> ((lst !! i), (remove lst i))) [0..((length lst)-1)]
  where remove l i = (take i l) ++ (drop (i+1) l)

instance (Show a, DataPoint a) => Show (Stage a) where
  show (Stage lst) = (join (map show lst) "  -  ") ++ " (Best distance: " ++ (show $ bestDistance (Stage lst)) ++ ")"

bestStage :: DataPoint a => [(Stage a)] -> Stage a
bestStage [stage] = stage
bestStage stages = snd $ head $ sortOn (\(stage1, stage2) -> (bestDistance stage1) - (bestDistance stage2)) $ map (\(i, j) -> ((stages !! i), (stages !! j))) [(i, i + 1) | i <- [0..((length stages) - 2)]]

allStagesFromData :: DataPoint a => Show a => [a] -> [Stage a]
allStagesFromData ds = completeStagesWith (newStageFromData ds) []
  where completeStagesWith stage stages
          | (stageNodeListLength stage) == 1 = (stage:stages)
          | otherwise = completeStagesWith (obtainedNextStage stage) (stage:stages)
        obtainedNextStage stage = nextStage stage
        stageNodeListLength (Stage lst) = length lst

bestStageFromData :: DataPoint a => Show a => [a] -> Stage a
bestStageFromData = bestStage . allStagesFromData

testStage :: [Float] -> IO ()
testStage ds = putStrLn $ show $ bestStageFromData ds
