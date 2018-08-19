module Node where

import DataPoint

data Node a = Node a

a = Node 2

instance DataPoint a => DataPoint (Node a) where
  distance (Node x) (Node y) = distance x y

instance Show a => Show (Node a) where
  show (Node x) = show x
