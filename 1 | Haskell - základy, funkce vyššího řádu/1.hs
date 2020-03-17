factorial :: Int -> Either String Int
factorial n =
    if n < 0
        then Left "Error"
        else Right n * factorial (n - 1)
