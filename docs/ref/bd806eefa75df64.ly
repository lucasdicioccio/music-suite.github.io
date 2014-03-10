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
    \new Staff {   \set Staff.instrumentName = "" \set Staff.shortInstrumentName = "" \time 4/4 \times 4/5
                                                                                                       {   \clef treble c'2 d'2 e'4~
                                                                                                       } \times 4/5
                                                                                                                {   e'4 f'2 g'2
                                                                                                                }
               }
    \new Staff {   \set Staff.instrumentName = "" \set Staff.shortInstrumentName = "" \time 4/4 \times 4/5
                                                                                                       {   \clef treble c'2 bes2 aes4~
                                                                                                       } \times 4/5
                                                                                                                {   aes4 g2 f2
                                                                                                                }
               }
    \new Staff {   \set Staff.instrumentName = "" \set Staff.shortInstrumentName = "" \time 4/4 \times 4/5
                                                                                                       {   \clef treble gis'2 fis'2 e'4~
                                                                                                       } \times 4/5
                                                                                                                {   e'4 dis'2 cis'2
                                                                                                                }
               }
>>