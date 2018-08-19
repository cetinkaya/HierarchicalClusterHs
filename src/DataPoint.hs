{-# LANGUAGE FlexibleInstances #-}
module DataPoint where

class DataPoint a where
  distance :: a -> a -> Float

instance DataPoint Float where
  distance x y = abs $ (x - y)

instance DataPoint ([] Float) where
  distance xs ys = sqrt $ sum $ zipWith (\x y -> (x - y) * (x - y)) xs ys

