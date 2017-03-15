\begin{code}
{-# LANGUAGE NoImplicitPrelude          #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE CPP                        #-}
#if __GLASGOW_HASKELL__ >= 800
{-# OPTIONS_GHC -fno-warn-redundant-constraints #-}
#endif

module Text.RE.Tools.Sed
  ( SedScript
  , sed
  , sed'
  ) where

import qualified Data.ByteString.Lazy.Char8               as LBS
import           Prelude.Compat
import           Text.RE.Tools.Edit
import           Text.RE.Types.LineNo
import           Text.RE.Types.IsRegex


type SedScript re = Edits IO re LBS.ByteString

sed :: IsRegex re LBS.ByteString
    => SedScript re
    -> FilePath
    -> FilePath
    -> IO ()
sed as i_fp o_fp = do
  lns  <- LBS.lines <$> read_file i_fp
  lns' <- sequence
    [ applyEdits lno as s
        | (lno,s)<-zip [firstLine..] lns
        ]
  write_file o_fp $ LBS.concat lns'

sed' :: (IsRegex re LBS.ByteString,Monad m,Functor m)
     => Edits m re LBS.ByteString
     -> LBS.ByteString
     -> m LBS.ByteString
sed' as lbs = do
  LBS.concat <$> sequence
    [ applyEdits lno as s
        | (lno,s)<-zip [firstLine..] $ LBS.lines lbs
        ]

read_file :: FilePath -> IO LBS.ByteString
read_file "-" = LBS.getContents
read_file fp  = LBS.readFile fp

write_file :: FilePath -> LBS.ByteString ->IO ()
write_file "-" = LBS.putStr
write_file fp  = LBS.writeFile fp
\end{code}
