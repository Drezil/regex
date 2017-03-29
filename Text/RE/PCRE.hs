{-# LANGUAGE FlexibleContexts               #-}
{-# LANGUAGE CPP                            #-}
{-# OPTIONS_GHC -fno-warn-duplicate-exports #-}
#if __GLASGOW_HASKELL__ >= 800
{-# OPTIONS_GHC -fno-warn-redundant-constraints #-}
#endif
{-# OPTIONS_GHC -fno-warn-dodgy-exports #-}

module Text.RE.PCRE
  (
  -- * Tutorial
  -- $tutorial

  -- * About this Module
  -- $about

  -- * The Match Operators
    (*=~)
  , (?=~)
  -- * The SearchReplace Operators
  , (*=~/)
  , (?=~/)
  -- * The Classic rexex-base Match Operators
  , (=~)
  , (=~~)
  -- * Matches
  , Matches
  , matchesSource
  , allMatches
  , anyMatches
  , countMatches
  , matches
  -- * Match
  , Match
  , matchSource
  , matched
  , matchedText
  -- * The 'RE' Type and Functions
  , RE
  , SimpleREOptions(..)
  , reSource
  , compileRegex
  , compileRegexWith
  , escape
  , escapeWith
  , escapeREString
  , module Text.RE.ZeInternals.PCRE
  -- * The [ed| ... |] quasi quoters
  , module Text.RE.ZeInternals.SearchReplace.PCRE
  -- * The Operator Instances
  -- $instances
  , module Text.RE.PCRE.ByteString
  , module Text.RE.PCRE.ByteString.Lazy
  , module Text.RE.PCRE.Sequence
  , module Text.RE.PCRE.String

  ) where


import qualified Text.Regex.Base                          as B
import           Text.RE
import           Text.RE.ZeInternals.AddCaptureNames
import           Text.RE.ZeInternals.SearchReplace.PCRE
import           Text.RE.ZeInternals.PCRE
import qualified Text.Regex.PCRE                          as PCRE
import           Text.RE.PCRE.ByteString()
import           Text.RE.PCRE.ByteString.Lazy()
import           Text.RE.PCRE.Sequence()
import           Text.RE.PCRE.String()
import           Text.RE.IsRegex
import           Text.RE.REOptions


-- | find all matches in text; e.g., to count the number of naturals in s:
--
--   @countMatches $ s *=~ [re|[0-9]+|]@
--
(*=~) :: IsRegex RE s
      => s
      -> RE
      -> Matches s
(*=~) bs rex = addCaptureNamesToMatches (reCaptureNames rex) $ matchMany rex bs

-- | find first match in text
(?=~) :: IsRegex RE s
      => s
      -> RE
      -> Match s
(?=~) bs rex = addCaptureNamesToMatch (reCaptureNames rex) $ matchOnce rex bs

-- | search and replace once
(?=~/) :: IsRegex RE s => s -> SearchReplace RE s -> s
(?=~/) = flip searchReplaceFirst

-- | search and replace, all occurrences
(*=~/) :: IsRegex RE s => s -> SearchReplace RE s -> s
(*=~/) = flip searchReplaceAll

-- | the regex-base polymorphic match operator
(=~) :: ( B.RegexContext PCRE.Regex s a
        , B.RegexMaker   PCRE.Regex PCRE.CompOption PCRE.ExecOption s
        )
     => s
     -> RE
     -> a
(=~) bs rex = B.match (reRegex rex) bs

-- | the regex-base monadic, polymorphic match operator
(=~~) :: ( Monad m
         , B.RegexContext PCRE.Regex s a
         , B.RegexMaker   PCRE.Regex PCRE.CompOption PCRE.ExecOption s
         )
      => s
      -> RE
      -> m a
(=~~) bs rex = B.matchM (reRegex rex) bs

-- $tutorial
-- We have a regex tutorial at <http://tutorial.regex.uk>.

-- $about
-- This module provides access to the back end through polymorphic functions
-- that operate over all of the String/Text/ByteString types supported by the
-- PCRE back end. If you don't need this generality you might find it easier
-- to work with one of the modules that have been specialised for each of these
-- types:
--
-- * "Text.RE.PCRE.ByteString"
-- * "Text.RE.PCRE.ByteString.Lazy"
-- * "Text.RE.ZeInternals.PCRE"
-- * "Text.RE.PCRE.Sequence"
-- * "Text.RE.PCRE.String"

-- $instances
--
-- These modules merely provide the 'IsRegex' instances.
