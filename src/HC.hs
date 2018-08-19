module HC (findClusterAuto, findCluster) where

import Data.Text as T
import Data.Text.IO as TIO
import Stage
import DataPoint
import Node
import NodeList

lineToData :: Text -> [Float]
lineToData t = Prelude.map (\part -> read $ unpack part) parts
  where parts = T.splitOn (pack " ") t

readData :: String -> IO [[Float]]
readData filename = fmap (\lsn -> Prelude.map lineToData lsn) $ ls filename
  where ls filename = fmap T.lines $ TIO.readFile filename

dataToText :: [Float] -> Int -> Text
dataToText fs cluster = T.concat ((Prelude.map (\f -> (pack $ ((show f) ++ " "))) fs) ++ [pack $ show cluster])

textJoin :: [Text] -> Text -> Text
textJoin [] _  = pack $ ""
textJoin (t:ts) sep = T.concat (t:(Prelude.map (\s -> T.concat [sep, s]) ts))

stageToText :: Stage [Float] -> Text
stageToText (Stage lst) = textJoin (Prelude.zipWith nodeListToText lst [1..]) $ pack "\n"

writeStage :: String -> Stage [Float] -> IO ()
writeStage filename stage = TIO.writeFile filename $ stageToText stage

nodeListToText :: NodeList [Float] -> Int -> Text
nodeListToText (NodeList nodes) cluster = textJoin (Prelude.zipWith (\(Node d) cluster -> dataToText d cluster) nodes [cluster, cluster..]) $ pack "\n"

testStageNew :: [[Float]] -> IO ()
testStageNew ds = TIO.putStrLn $ stageToText $ bestStageFromData ds

findClusterAuto :: String -> String -> IO ()
findClusterAuto dataFilename dataWithClustersFilename = (fmap bestStageFromData $ readData dataFilename) >>= (writeStage dataWithClustersFilename)

findCluster :: String -> String -> Int -> IO ()
findCluster dataFilename dataWithClustersFilename clusterCount = (fmap ((!! (clusterCount - 1)) . allStagesFromData) $ readData dataFilename) >>= (writeStage dataWithClustersFilename)
