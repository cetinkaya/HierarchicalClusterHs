module Main where

import HC
import System.Environment

main :: IO ()
main = do
  args <- getArgs
  if length args < 2
    then putStrLn "Supply dataFilename and withClusterDataFilename as command line arguments."
    else if length args == 2
           then findClusterAuto (args !! 0) (args !! 1)
           else findCluster (args !! 0) (args !! 1) ((read $ args !! 2)::Int)
