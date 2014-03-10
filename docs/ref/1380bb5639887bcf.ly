\include "lilypond-book-preamble.ly"
\paper {
  #(define dump-extents #t)

  indent = 0\mm
  line-width = 210\mm - 2.0 * 0.4\in
  ragged-right = ##t
  force-assignment = #""
  line-width = #(- line-width (* mm  3.000000))
}
\header {
  title = ""
  composer = ""
}
\layout {
}

<<
    \new Staff {   \set Staff.instrumentName = "" \set Staff.shortInstrumentName = "" \time 4/4 \clef bass {   c8-. g8-. c'8-. g8-. aes8-. ees'8-. d'8-. a'8-.
                                                                                                           } \time 2/4 \clef treble {   g'8-. fis'8-. e'8-. d'8-.->
                                                                                                                                    }
               }
>>