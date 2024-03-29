module TuringFuncs (computation)  where

import Control.Monad ((<=<))
import Data.List (find)

import TuringData


-- Výpočet TM je posloupnost konfigurací a výsledek
computation :: TMachine -> Tape -> ([TMConfig], String)
computation tm tape = iterE (nextConfig tm) (TMConf (start tm) tape)

-- Změna konfigurace jedním krokem výpočtu
nextConfig :: TMachine -> TMConfig -> Err TMConfig
nextConfig tm cf@(TMConf q _) =
    if q == end tm then Left "accepted"
      else either Left (step cf) (findRule cf (transRules tm))

-- Krok výpočtu podle pravidla přech. funkce
step :: TMConfig -> Transition -> Err TMConfig
-- Cv: DOPLŇTE DEFINICI
step (TMConf _ (Tape x (l:tpl) tpr))
             (Trans _ _ q ALeft)      = Right $ TMConf q (Tape l tpl (x:tpr))  -- DOPLNIT
step (TMConf _ (Tape x tpl (r:tpr)))
             (Trans _ _ q ARight)     = Right $ TMConf q (Tape r (x:tpl) tpr)  -- DOPLNIT
step (TMConf _ (Tape _ tpl tpr))
             (Trans _ _ q (AWrite w)) = Right $ TMConf q (Tape w tpl tpr)  -- DOPLNIT
step (TMConf _ (Tape _ [] _))
             (Trans _ _ _ ALeft)      = Left "bumping tape edge"  -- DOPLNIT
step (TMConf _ (Tape _ _ []))
             _                        = Left "beyond infinity?"  -- DOPLNIT

-- Vyhledání pravidla v seznamu
findRule :: TMConfig -> [Transition] -> Err Transition
findRule cfg@(TMConf q (Tape x _ _)) =
    maybeToEither "no transition" . find (\(Trans u c v a) -> q==u && x==c)
  where
      maybeToEither :: e -> Maybe a -> Either e a
      -- Cv: VYJÁDŘETE JEDNÍM ŘÁDKEM POMOCÍ maybe
      maybeToEither e = maybe (Left e) Right
      -- maybeToEither e (Just a) = Right a
      -- maybeToEither e Nothing  = Left e
