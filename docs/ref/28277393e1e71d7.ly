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
    \new Staff {   \set Staff.instrumentName = "" \clef treble <c'>8 <d'>8 <f'>8 <e'>8 <g'>16 <a'>16 <c''>16 <b'>16 <c''>4~ <c''>4 <d''>2 <f''>4~ <f''>4 <e''>2
               }
>>