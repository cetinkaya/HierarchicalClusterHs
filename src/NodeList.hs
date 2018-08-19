module NodeList where

import Node
import DataPoint
import Data.List

data NodeList a = NodeList [Node a]

instance DataPoint a => DataPoint (NodeList a) where
  distance (NodeList nodes1) (NodeList nodes2) = minimum [distance node1 node2 | node1 <- nodes1, node2 <- nodes2]

join :: Show a => [a] -> String -> String
join xs sep = (concatMap (\(x, y) -> (show x) ++ y) $ zip (take ((length xs) -1) xs) (repeat sep)) ++ (show $ last xs)

instance Show a => Show (NodeList a) where
  show (NodeList lst) = join lst ", "

mergeTwoNodeLists :: DataPoint a => NodeList a -> NodeList a -> NodeList a
mergeTwoNodeLists (NodeList nodes1) (NodeList nodes2) = NodeList (nodes1 ++ nodes2)
