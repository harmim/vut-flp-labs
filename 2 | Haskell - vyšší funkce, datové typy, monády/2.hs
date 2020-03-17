import Control.Monad


data Vector a = Vec Int [a]

initVector :: [a] -> Vector a
initVector xs = Vec (length xs) xs

dotProd :: Num a => Vector a -> Vector a -> Maybe a
dotProd (Vec l1 xs1) (Vec l2 xs2) = if l1 == l2 then Just (sum (zipWith (*) xs1 xs2)) else Nothing


type Clovek = String

otec :: Clovek -> Maybe Clovek
otec "Karel" = Just "Evzen"
otec "Evzen" = Just "Dobromil"
otec "Dobromil" = Just "Franta"
otec _ = Nothing

dedecek :: Clovek -> Maybe Clovek
dedecek = otec <=< otec

pradedecek :: Clovek -> Maybe Clovek
pradedecek = otec <=< otec <=< otec


psychiatr :: IO ()
psychiatr = do
  x <- getLine
  unless (x == "") $ do
    putStrLn x
    psychiatr
