

# Getting Started

## Installing the Suite

The Music Suite depends on the [Haskell platform][HaskellPlatform].

While not strictly required, [Lilypond][Lilypond] is highly recommended as it allow you to
preview musical scores. See [Import and Export](#import-and-export) for other formats.

To install the suite, simply install the Haskell platform, and then run:

    cabal install music-preludes


## Writing music

This chapter will cover how to use the Music Suite to generate music. Later on we will cover how to *import* and *transform* music.

One of the main points of the Music Suite is to avoid committing to a *single*, closed music representation. Instead it provides a set of types and type constructors that can be used to construct an arbitrary representation of music. 

Usually you will not want to invent a new representation from scratch, but rather start with a standard representation and customize it when needed. The default representation is defined in the `Music.Prelude.Basic` module, which is implicitly imported in all the examples below. See [Customizing the Music Representation](#customizing-music-representation) for other examples.


### With music files

A piece of music is described by a *expressions* such as this one:

```haskell
c |> d |> e

```

The simplest way to render this expression is to save it in a file named
`foo.music` (or similar) and convert it using `music2pdf foo.music`. This
should render a file called `foo.pdf` containing the following:



![](e812b3370beb65fx.png)

There are several programs for converting music expressions:

* `music2mid` 
* `music2musicxml` 
* `music2ly` 
* `music2wav` 
* `music2pdf`

### With Haskell files

Alternatively, you can create a file called `test.hs` (or similar) with the following structure:

```haskell
import Music.Prelude.Basic

main = defaultMain music
music = c |> d |> e

```

Then either execute it using:

    $ runhaskell test.hs
    
or compile and run it with

    $ ghc --make test
    $ ./test

In this case the resulting program will generate and open a file called
`test.pdf` containing the output seen above.

Music files and Haskell files using `defaultMain` are equivalent in every aspect. In fact, the `music2...` programs are simple utilities that substitutes a single expression into a Haskell module such as the one above and executes the resulting main function.

## Time and duration

A single note can be entered by its name. This will render a note in the middle octave with a duration of one. Note that note values and durations correspond exactly, a duration of `1` is a whole note, a duration of `1/2` is a half note, and so on.

<div class='haskell-music'>



![](344658b06e772a3ex.png)

```haskell
c

```

</div>

To change the duration of a note, use [`stretch`][stretch] or [`compress`][compress]. Note that:
    
```haskell
compress x = stretch (1/x)

```

for all values of *x*.

<div class='haskell-music'>



![](17acdbdbe31e8366x.png)

```haskell
stretch (1/2) c

```

</div>

<div class='haskell-music'>



![](c206dd98257abc9x.png)

```haskell
stretch 2 c         

```

</div>

<div class='haskell-music'>



![](47c74d92daacf31fx.png)

```haskell
stretch (4+1/2) c

```

</div>

TODO delay

Offset and duration is not limited to simple numbers. Here are some more complex examples:

<div class='haskell-music'>



![](7989d1133a0ecb36x.png)

```haskell
c^*(9/8) |> d^*(7/8)

```

</div>

<div class='haskell-music'>



![](4247fd44e823a93fx.png)

```haskell
stretch (2/3) (scat [c,d,e]) |> f^*2

```

</div>

As you can see, note values, tuplets and ties are added automatically

The `^*` and `^/` operators can be used as shorthands for `delay` and `compress`.

<div class='haskell-music'>



![](6e082ce15a9e3be5x.png)

```haskell
(c |> d |> e |> c |> d^*2 |> d^*2)^/16

```

</div>


Allthough the actual types are more general, you can think of `c` as an expression
of type `Score Note`, and the transformations as functions `Score Note -> Score Note`.

<div class='haskell-music'>



![](72259aeb0502b2ebx.png)

```haskell
up (perfect octave) . compress 2 . delay 3 $ c

```

</div>


## Composition

Music expressions can be composed [`<>`][<>]:

<div class='haskell-music'>



![](2417d7f318b299eex.png)

```haskell
c <> e <> g

```

</div>

TODO fundamentally, `<>` is the only way to compose music...

Or in sequence using [`|>`][|>]:

<div class='haskell-music'>



![](e812b3370beb65fx.png)

```haskell
c |> d |> e

```

</div>

Or partwise using [`</>`][</>]:

<div class='haskell-music'>



![](59dcbb2937c2906cx.png)

```haskell
c </> e </> g

```

</div>

Here is a more complex example:

<div class='haskell-music'>



![](28c98e09d9084e17x.png)

```haskell
let            
    scale = scat [c,d,e,f,g,a,g,f]^/8
    triad a = a <> up _M3 a <> up _P5 a
in up _P8 scale </> (triad c)^/2 |> (triad g_)^/2

```

</div>

As a shorthand for `x |> y |> z ..`, we can write [`scat`][scat] `[x, y, z]` (short for *sequential concatenation*).

<div class='haskell-music'>



![](8dcc23c8a43be98x.png)

```haskell
scat [c,e..g]^/4

```

</div>

For `x <> y <> z ..`, we can write [`pcat`][pcat] `[x, y, z]` (short for *parallel concatenation*).

<div class='haskell-music'>



![](1a42f3fa65506151x.png)

```haskell
pcat [c,e..g]^/2

```

</div>

Actually, [`scat`][scat] and [`pcat`][pcat] used to be called `melody` and `chord` back in the days, but
I figured out that these are names that you actually want to use in your own code.

## Pitch

### Pitch names

To facilitate the use of non-standard pitch, the standard pitch names are provided as overloaded values, referred to as *pitch literals*. 

To understand how this works, think about the type of numeric literal. The values $0, 1, 2$ etc. have type `Num a => a`, similarly, the pitch literals $c, d, e, f ...$ have type [`IsPitch`][IsPitch] `a => a`.

For Western-style pitch types, the standard pitch names can be used:

<div class='haskell-music'>



![](6cfe439b3533d41ax.png)

```haskell
scat [c, d, e, f, g, a, b]

```

</div>

Pitch names in other languages work as well, for example `ut, do, re, mi, fa, so, la, ti, si`. 

<!--
German names (using `h` and `b` instead of `b` and `bb`) can be approximated as follows:

```haskell
import Music.Preludes.Basic hiding (b)
import qualified Music.Pitch.Literal as P

h = P.b
b = P.bb

```
-->


You can change octave using `octavesUp` and `octavesDown`:

<div class='haskell-music'>



![](5ee112ca5880e24ax.png)

```haskell
octavesUp 4 c
    </>
octavesUp (-1) c
    </>
octavesDown 2 c

```

</div>

There is also a shorthand for other octaves:

<div class='haskell-music'>



![](762a2558558e6d28x.png)

```haskell
c__ |> c_ |> c |> c' |> c''

```

</div>

Sharps and flats can be added by the functions [`sharp`][sharp] and [`flat`][flat], which are written 
*postfix* thanks to some overloading magic.

<div class='haskell-music'>



![](7d4cbd690475a6c8x.png)

```haskell
c sharp |> d |> e flat

```

</div>

You can also use the ordinary (prefix) versions `sharpen` and `flatten`.

<div class='haskell-music'>



![](1101f1aee219368ex.png)

```haskell
sharpen c 
    </> 
(sharpen . sharpen) c

```

</div>

As you might expect, there is also a shorthand for sharp and flat notes:

<div class='haskell-music'>



![](2fb5ed23f747e89cx.png)

```haskell
(cs |> ds |> es)    -- sharp
    </>
(cb |> db |> eb)    -- flat

```

</div>

Here is an overview of all pitch notations:

```haskell
sharpen c             == c sharp       == cs
flatten d             == d flat        == ds
(sharpen . sharpen) c == c doubleSharp == css
(flatten . flatten) d == d doubleFlat  == dss

```

Note that `cs == db` may or may not hold depending on which pitch representation you use.

### Interval names

Interval names are overloaded in a manner similar to pitches, and are consequently referred to as *interval literals*. The corresponding class is called [`IsInterval`][IsInterval].

Here and elsewhere in the Music Suite, the convention is to follow standard theoretical
notation, so *minor* and *diminished* intervals are written in lower-case, while *major*
and *perfect* intervals are written in upper-case. Unfortunately, Haskell does not support
overloaded upper-case values, so we have to adopt an underscore prefix:

```haskell
minor third      == m3
major third      == _M3
perfect fifth    == _P5
diminished fifth == d5
minor ninth      == m9

```

Similar to [`sharpen`][sharpen] and [`flatten`][flatten], the [`augment`][augment] and [`diminish`][diminish] functions can be used
to alter the size of an interval. For example:

<div class='haskell-music'>



![](72c9aad78038ac0cx.png)

```haskell
let
    intervals = [diminish (perfect fifth), (diminish . diminish) (perfect fifth)]
in scat $ fmap (`up` c) intervals

```

</div>

You can add pitches and intervals using the [`.-.`][.-.] and [`.+^`][.+^] operators. To memorize these
operators, think of pitches and points `.` and intervals as vectors `^`.

<div class='haskell-music'>



![](43d6c0b4d2b8d1b0x.png)

```haskell
setPitch (c .+^ m3) $ return c_

```

</div>


### Qualified pitch and interval names

There is nothing special about the pitch and interval literals, they are simply values exported by the `Music.Pitch.Literal` module. While this module is reexported by the standard music preludes, you can also import it qualified if you want to avoid bringing the single-letter pitch names into scope.

```haskell
Pitch.c |> Pitch.d .+^ Interval.m3

```

TODO overloading, explain why the following works:

```haskell
return (c::Note) == (c::Score Note)

```

## Dynamics

Dynamic values are overloaded in the same way as pitches. The dynamic literals are defined in `Music.Dynamics.Literal` and have type `IsDynamics a => a`.

An overview of the dynamic values:

<div class='haskell-music'>



![](73dd0a315ca1480x.png)

```haskell
scat $ zipWith dynamics [fff,ff,_f,mf,mp,_p,pp,ppp] [c..]

```

</div>

TODO other ways of applying dynamics

## Articulation

Some basic articulation functions are [`legato`][legato], [`staccato`][staccato], [`portato`][portato], [`tenuto`][tenuto], [`separated`][separated], [`spiccato`][spiccato]:

<div class='haskell-music'>



![](4e0bf333c3a1253bx.png)

```haskell
legato (scat [c..g]^/8)
    </>
staccato (scat [c..g]^/8)
    </>
portato (scat [c..g]^/8)
    </>
tenuto (scat [c..g]^/8)
    </>
separated (scat [c..g]^/8)
    </>
spiccato (scat [c..g]^/8)

```

</div>

[`accent`][accent]
[`marcato`][marcato]

<div class='haskell-music'>



![](7505c58579d6f2ebx.png)

```haskell
accent (scat [c..g]^/8)
    </>
marcato (scat [c..g]^/8)

```

</div>

[`accentLast`][accentLast]
[`accentAll`][accentAll]

<div class='haskell-music'>



![](222067bf4985543dx.png)

```haskell
accentLast (scat [c..g]^/8)
    </>
accentAll (scat [c..g]^/8)

```

</div>

Applying articulations over multiple parts:

<div class='haskell-music'>



![](6d6121cf5a1057ffx.png)

```haskell
let
    p1 = scat [c..c']^/4
    p2 = delay (1/4) $ scat [c..c']^/4
    p3 = delay (3/4) $ scat [c..c']^/4
in (accent . legato) (p1 </> p2 </> p3)

```

</div>

## Parts

TODO

## Space

TODO

## Tremolo

[`tremolo`][tremolo]

<div class='haskell-music'>



![](33035e5b50c27efax.png)

```haskell
tremolo 2 $ times 2 $ (c |> d)^/2

```

</div>

## Slides and glissando

[`slide`][slide]
[`glissando`][glissando]

<div class='haskell-music'>



![](455023b9c80482a0x.png)

```haskell
glissando $ scat [c,d]^/2

```

</div>

## Harmonics

Use the [`harmonic`][harmonic] function:

<div class='haskell-music'>



![](3577bdcff02045ddx.png)

```haskell
(harmonic 1 $ c^/2)
    </>
(harmonic 2 $ c^/2)
    </>
(harmonic 3 $ c^/2)

```

</div>
[`artificial`][artificial]


## Text

[`text`][text]

<div class='haskell-music'>



![](5351da121c9bf05dx.png)

```haskell
text "pizz." $ c^/2

```

</div>
## Chords

TODO

## Rests

Sometimes it is useful to work with scores that have a duration but no events.
This kind of score is represented by `rest` and has the type `Score (Maybe
Note)`. We use [`removeRests`][removeRests] to convert a `Score (Maybe a)`
into a `Score a`.

<div class='haskell-music'>



![](655bf6c96f41cdbfx.png)

```haskell
removeRests $ times 4 (accent g^*2 |> rest |> scat [d,d]^/2)^/8

```

</div>
                 



# Transformations

## Time

[`rev`][rev]

<div class='haskell-music'>



![](339ae0c0fd3b9259x.png)

```haskell
let
    melody = accent $ legato $ scat [d, scat [g,fs]^/2,bb^*2]^/4
in melody |> rev melody

```

</div>

[`times`][times]

<div class='haskell-music'>



![](701c5015f33304a4x.png)

```haskell
let
    melody = legato $ scat [c,d,e,c]^/16
in times 4 $ melody

```

</div>

[`sustain`][sustain]

<div class='haskell-music'>



![](60dc3260048dae39x.png)

```haskell
scat [e,d,f,e] <> c

```

</div>


[`anticipate`][anticipate]

[`repeated`][repeated]

<div class='haskell-music'>



![](209d91caa25c1affx.png)

```haskell
let 
    m = legato $ scat [c,d,scat [e,d]^/2, c]^/4 
in [c,eb,ab,g] `repeated` (\p -> up (asPitch p .-. c) m)

```

</div>

## Onset and duration

<div class='haskell-music'>



![](6f4bfbf5a4d6c76ax.png)

```haskell
let                
    melody = asScore $ legato $ scat [scat [c,d,e,c], scat [e,f], g^*2]
    pedal  = asScore $ delayTime (onset melody) $ stretch (duration melody) $ c_
in compress 4 $ melody </> pedal

```

</div>

## Pitch

[`invertAround`][invertAround]

<div class='haskell-music'>



![](bd806eefa75df64x.png)

```haskell
(scat [c..g]^*(2/5))
    </>
(invertAround c $ scat [c..g]^*(2/5))
    </>
(invertAround e $ scat [c..g]^*(2/5))

```

</div>


## Pitches and intervals

## Name and accidental

## Spelling

## Quality and number


## Intonation

TODO

## Inspecting dissonant intervals

## Semitones and enharmonic equivalence

## Spelling

## Scales

## Chords



## Parts

## Instrument, part and sub-part

## Extracting and modifying parts

## Part composition



# Time-based structures

[`Score`][Score]
[`Voice`][Voice]
[`Track`][Track]
[`Delayable`][Delayable]
[`Stretchable`][Stretchable]


## Time and duration

TODO

## Spans

TODO

## Notes

TODO

## Voice

A [`Voice`][Voice] represents a single voice of music. It consists of a sequence of values with duration, but no time. 

<div class='haskell-music'>



![](786d2383245b9c9dx.png)

```haskell
stretch (1/4) $ scat [c..a]^/2 |> b |> c'^*4

```

</div>

<div class='haskell-music'>



![](6391c8a4c4a26fdbx.png)

```haskell
stretch (1/2) $ scat [c..e]^/3 |> f |> g^*2

```

</div>


It can be converted into a score by stretching each element and composing in sequence.

<div class='haskell-music'>



![](28277393e1e71d7x.png)

```haskell
let
    x, y :: Voice Note

    x = voice [ (1, c),
                (1, d),
                (1, f),
                (1, e) ]

    y = join $ voice [ (1, x), 
                       (0.5, up _P5 x), 
                       (4, up _P8 x) ]

in stretch (1/8) $ voiceToScore $ y

```

</div>

## Tracks

A [`Track`][Track] is similar to a score, except that it events have no offset or duration. It is useful for representing point-wise occurrences such as samples, cues or percussion notes.

It can be converted into a score by delaying each element and composing in parallel. An explicit duration has to be provided.

<div class='haskell-music'>



![](202ddfede2859c40x.png)

```haskell
let
    x, y :: Track Note
    x = track [ (0, c), (1, d), (2, e) ]
    y = join $ track [ (0, x), (1.5,  up _P5 x), (3.25, up _P8 x) ]
in trackToScore (1/8) y

```

</div>


# Meta-information

It is often desirable to annotate music with extraneous information, such as title, creator, time signature and so on. In the Music Suite these are grouped together under the common label *meta-information*.

The distinction between ordinary musical data and meta-data is not always clear cut. For example, while a clef is clearly a presentation detail, a key signature might be considered both a presentation aspect and a fundamental aspect of the musical syntax.

TODO while we only consider notes as non-meta etc

TODO attributes (same as in Diagrams)

Each attribute value may apply either to a *whole* score (i.e. from beginning to end), or to a *section* of the score.

## Title

TODO

```haskell
title "Frere Jaques" $ scat [c,d,e,c]

```

## Movement title and number

TODO

## Attribution

TODO

```haskell
composer "Anonymous" $ scat [c,d,e,c]

```

## Clefs

To set the clef for a whole passage, use [`setClef`][setClef]. The clef is used by most notation backends and ignored by audio backends.

<div class='haskell-music'>



![](15619c9b3f4e426bx.png)

```haskell
let
    part1 = setClef FClef $ staccato $ scat [c_,g_,c,g_]
    part2 = setClef CClef $ staccato $ scat [ab_,eb,d,a]
    part3 = setClef GClef $ staccato $ accentLast $ scat [g,fs,e,d]
in compress 8 $ part1 |> part2 |> part3

```

</div>

To set the clef for a preexisting passage in an existing score, use [`setClefDuring`][setClefDuring].

<div class='haskell-music'>



![](2e371040c015a646x.png)

```haskell
setClefDuring (0.25 <-> 0.5) CClef $ setClefDuring (0.75 <-> 1) FClef $ compress 8 $ scat [c_..c']

```

</div>

## Time signatures          

TODO

## Key signatures

<div class='haskell-music'>



![](1bab6df801a2845dx.png)

```haskell
setKeySignature (key cs True) c |> setKeySignature (key ab False) c

```

</div>

## Rehearsal marks

TODO

## Miscellaneous

TODO

# Import and export

The standard distribution (installed as part of `music-preludes`) of the Music Suite includes a variety of input and output formats. There are also some experimental formats, which are distributed in separate packages, these are marked as experimental below.

The conventions for input or output formats is similar to the convention for properties (TODO ref above): for any type `a` and format `T a`, input formats are defined by a class or constraint `IsT`, and output by a format `HasT a`. For example, types that can be exported to Lilypond are defined by the constraint `HasLilypond a`, while types that can be imported from MIDI are defined by the constraint `IsMidi a`.

## MIDI

All standard representations support MIDI input and output. The MIDI representation uses [HCodecs](http://hackage.haskell.org/package/HCodecs) and the real-time support uses [hamid](http://hackage.haskell.org/package/hamid). 

<!--
You can read and write MIDI files using the functions [`readMidi`][readMidi] and [`writeMidi`][writeMidi]. To play MIDI back in real-time, use [`playMidi`][playMidi] or [`playMidiIO`][playMidiIO], which uses [reenact](http://hackage.haskell.org/package/reenact).
-->

Beware that MIDI input may contain time and pitch values that yield a non-readable notation, you need an sophisticated piece of analysis software to convert raw MIDI input to quantized input.

## Lilypond

All standard representations support Lilypond output. The [lilypond](http://hackage.haskell.org/package/lilypond) package is used for parsing and pretty printing of Lilypond syntax. Lilypond is the recommended way of rendering music.

Lilypond input is not available yet but will hopefully be added soon.

An example:

```haskell
toLyString $ asScore $ scat [c,d,e]

```

    <<
        \new Staff { <c'>1 <d'>1 <e'>1 }
    >>


## MusicXML

All standard representations support MusicXML output. The [musicxml2](http://hackage.haskell.org/package/musicxml2) package is used for 
parsing and pretty printing. 

The output is fairly complete, with some limitations ([reports][issue-tracker] welcome). There are no plans to support input in the near future.

Beware of the extreme verboseness of XML, for example:

```haskell
toXmlString $ asScore $ scat [c,d,e]

```

    <?xml version='1.0' ?>
    <score-partwise>
      <movement-title>Title</movement-title>
      <identification>
        <creator type="composer">Composer</creator>
      </identification>
      <part-list>
        <score-part id="P1">
          <part-name></part-name>
        </score-part>
      </part-list>
      <part id="P1">
        <measure number="1">
          <attributes>
            <key>
              <fifths>0</fifths>
              <mode>major</mode>
            </key>
          </attributes>
          <attributes>
            <divisions>768</divisions>
          </attributes>
          <direction>
            <direction-type>
              <metronome>
                <beat-unit>quarter</beat-unit>
                <per-minute>60</per-minute>
              </metronome>
            </direction-type>
          </direction>
          <attributes>
            <time symbol="common">
              <beats>4</beats>
              <beat-type>4</beat-type>
            </time>
          </attributes>
          <note>
            <pitch>
              <step>C</step>
              <alter>0.0</alter>
              <octave>4</octave>
            </pitch>
            <duration>3072</duration>
            <voice>1</voice>
            <type>whole</type>
          </note>
        </measure>
        <measure number="2">
          <note>
            <pitch>
              <step>D</step>
              <alter>0.0</alter>
              <octave>4</octave>
            </pitch>
            <duration>3072</duration>
            <voice>1</voice>
            <type>whole</type>
          </note>
        </measure>
        <measure number="3">
          <note>
            <pitch>
              <step>E</step>
              <alter>0.0</alter>
              <octave>4</octave>
            </pitch>
            <duration>3072</duration>
            <voice>1</voice>
            <type>whole</type>
          </note>
        </measure>
      </part>
    </score-partwise>
    

## ABC Notation

ABC notation (for use with [abcjs](http://code.google.com/p/abcjs/) or similar engines) is still experimental.

## Guido

Guido output (for use with the [GUIDO engine](http://guidolib.sourceforge.net/)) is not supported yet. This would be useful, as it allow real-time rendering of scores.

## Vextab

Vextab output (for use with [Vexflow](http://www.vexflow.com/)) is not supported yet.

## Sibelius

The [music-sibelius](http://hackage.haskell.org/package/music-sibelius) package provides experimental import of Sibelius scores (as MusicXML import is [not supported](#musicxml)).

<!--
This feature could of course also be used to convert Sibelius scores to other formats such as Guido or ABC without having to write in the ManuScript language used by Sibelius.
-->



# Customizing music representation

TODO

# Examples

Some more involved examples:

## Counterpoint


<div class='haskell-music'>



![](3147fc3d10ebefd6x.png)

```haskell
let                      
    subj = asScore $ scat [ c,       d,        f,          e           ]
    cs1  = asScore $ scat [ g,f,e,g, f,a,g,d', c',b,c',d', e',g',f',e' ]
in compress 4 cs1 </> subj

```

</div>

TODO about

<div class='haskell-music'>



![](509e242376de176ex.png)

```haskell
let subj = removeRests $ scat [ 
            scat [rest,c,d,e], 
            f^*1.5, scat[g,f]^/4, scat [e,a,d], g^*1.5,
            scat [a,g,f,e,f,e,d]^/2, c^*2 
        ]^/8

in (delay 1.5 . up _P5) subj </> subj

```

</div>

## Generative music

<div class='haskell-music'>



![](6e89c3525b872b20x.png)

```haskell
let
    row = cycle [c,eb,ab,asPitch g]
    mel = asScore $ scat [d, scat [g,fs]^/2,bb^*2]^/4
in (take 25 $ row) `repeated` (\p -> up (asPitch p .-. c) mel)

```

</div>

## Viola duo

<div class='haskell-music'>



![](73802e9c0977a59x.png)

```haskell
let
    toLydian = modifyPitch (\p -> if p == c then cs else p)

    subj1 = (^/2) $
        (legato.accent) (b_ |> c) |> (legato.accent) (c |> b_^*2)
            |> legato (scat [b_, c, d])
            |> b_ |> c |> b_^*2
        |> legato (scat [e, d, b_, c]) |> b_^*2
        |> scat [d, e, b_] |> c^*2 |> b_

    pres1 = subj1^*(2/2)
    pres2 = subj1^*(2/2) </> delay 2 (subj1^*(3/2))

    part1 = pres1 |> pres2
    part2 = pres1 |> pres2

in setClef CClef $ dynamics pp $ compress 2 $ part1 |> toLydian part2

```

</div>

<!--
### Schubert

```music+haskellx
let
    motive = (legato $ stretchTo 2 $ scat [g,a,bb,c',d',eb']) |> staccato (scat [d', bb, g])
    bar    = rest^*4

    song    = mempty
    left    = times 4 (times 4 $ removeRests $ triplet g)
    right   = removeRests $ times 2 (delay 4 motive |> rest^*3)

    triplet = group 3

    a `x` b = a^*(3/4) |> b^*(1/4)
    a `l` b = (a |> b)^/2

in  stretch (1/4) $ song </> left </> down _P8 right      
```
-->


# Design overview

<!--
To develop the Music Suite you need the following tools:

* Pandoc
* Transf
* Hslinks
* Lilypond

Most of these can be installed using `cabal install`.

There is a utility program called `music-util`, which simplifies the kind of cross-package development used throughout the Music Suite. This can be installed in the same manner as the packages, i.e. `cabal install music-util`. See [its documentation][music-util-docs] for an overview of the things it can do.

-->

TODO

The Music Suite consists of a number of packages. These can be divided into two categories: 

- *Music* packages that provide classes, types and functions related to a particular aspect of musical representation such as time, pitch, dynamics and so on. The name of these packages always begin with `music`.

- *Supporting* packages that implement a musical representation (`musicxml2`, `lilypond`, `abcnotation`), or miscellaneous functionality such as cross-platform MIDI support (`hamid`). These packages can be used as stand-alone packages but are included in the Suite for completeness.

There is no central package, instead the aim has been to separate the various issues that arise in music representations as clearly as possible. In particular, the `music-score` package, which provide scores and other temporal containers, does *not* depend on packages that provide models of musical aspects such as `music-pitch`, neither do these libraries depend on `music-score`. 

The reason for this is that we want to keep musical structure and content separate. This is a form of the [expression problem](http://en.wikipedia.org/wiki/Expression_problem): if one depended on the other we would either always force the user into a particular form of musical structure, or a particular form of musical material.

However, some packages have special roles:

- The `music-pitch-literal` and `music-dynamics-literal` are minimal packages that provide musical *literals*, i.e. common vocabulary overloaded on result type. This means other packages can import and provide instances for the literals without having to depend on a specific representation.

- The `music-preludes` provides modules that import modules from both `music-score` and `music-pitch` and its sister packages.


### Compability with other libraries

The Music Suite libraries does not profess to be compatible with any other music *representation* library^[Including Haskore, Euterpea, hts and temporal-media], and deliberately claims the whole `Music` top-level package. The aim is that functionality from these packages should eventually be included into the Music Suite packages. However it can be used with packages that implement audio processing, synthesis, interaction with musical instruments, FRP libraries and so on. 

The concepts and abstractions used in the suite overlap with some fundamental concepts form FRP, but the focus is fundamentally different. While FRP libraries focus on reacting to the external world, the Music Suite focus on modeling temporal values and musical concepts.


### Acknowledgements

The Music Suite is indebted to many other previous libraries and computer music environments, particularly [Common Music][common-music], [Max/MSP][max-msp], [SuperCollider][supercollider], [music21][music21], [Guido][guido], [Lilypond][lilypond] and [Abjad][abjad]. Some of the ideas for the quantization algorithms came from [Fomus][fomus].

It obviously ows a lot to the Haskell libraries that it follows including [Haskore][haskore], [Euterpea][euterpea] and [temporal-media][temporal-media]. The idea of defining a custom internal representation, but relying on standardized formats for input and output comes from [Pandoc][pandoc]. The idea of splitting the library into a set of packages (and the name) comes from the [Haskell Suite][haskell-suite]. The temporal structures, their instances and the concept of denotational design comes from [Reactive][reactive] (and its predecessors). [Diagrams][diagrams] provided the daring example and some general influences on the design.


<!--
![Modules](module-graph.png)
-->



[stretch]: /docs/api/Music-Time-Stretchable.html#v:stretch
[compress]: /docs/api/Music-Time-Stretchable.html#v:compress
[<>]: /docs/api/Music-Pitch.html#v:-60--62-
[|>]: /docs/api/Music-Time-Juxtapose.html#v:-124--62-
[</>]: /docs/api/Music-Score-Combinators.html#v:-60--47--62-
[scat]: /docs/api/Music-Time-Juxtapose.html#v:scat
[pcat]: /docs/api/Music-Time-Juxtapose.html#v:pcat
[IsPitch]: /docs/api/Music-Pitch-Literal-Pitch.html#t:IsPitch
[sharp]: /docs/api/Music-Pitch-Common-Accidental.html#v:sharp
[flat]: /docs/api/Music-Pitch-Common-Accidental.html#v:flat
[IsInterval]: /docs/api/Music-Pitch-Literal-Interval.html#t:IsInterval
[sharpen]: /docs/api/Music-Pitch-Alterable.html#v:sharpen
[flatten]: /docs/api/Music-Pitch-Alterable.html#v:flatten
[augment]: /docs/api/Music-Pitch-Augmentable.html#v:augment
[diminish]: /docs/api/Music-Pitch-Augmentable.html#v:diminish
[.-.]: /docs/api/Music-Pitch.html#v:-46--45--46-
[.+^]: /docs/api/Music-Pitch.html#v:-46--43--94-
[legato]: /docs/api/Music-Score-Articulation.html#v:legato
[staccato]: /docs/api/Music-Score-Articulation.html#v:staccato
[portato]: /docs/api/Music-Score-Articulation.html#v:portato
[tenuto]: /docs/api/Music-Score-Articulation.html#v:tenuto
[separated]: /docs/api/Music-Score-Articulation.html#v:separated
[spiccato]: /docs/api/Music-Score-Articulation.html#v:spiccato
[accent]: /docs/api/Music-Score-Articulation.html#v:accent
[marcato]: /docs/api/Music-Score-Articulation.html#v:marcato
[accentLast]: /docs/api/Music-Score-Articulation.html#v:accentLast
[accentAll]: /docs/api/Music-Score-Articulation.html#v:accentAll
[tremolo]: /docs/api/Music-Score-Ornaments.html#v:tremolo
[slide]: /docs/api/Music-Score-Ornaments.html#v:slide
[glissando]: /docs/api/Music-Score-Ornaments.html#v:glissando
[harmonic]: /docs/api/Music-Score-Ornaments.html#v:harmonic
[artificial]: /docs/api/Music-Score-Ornaments.html#v:artificial
[text]: /docs/api/Music-Score-Ornaments.html#v:text
[removeRests]: /docs/api/Music-Score-Combinators.html#v:removeRests
[rev]: /docs/api/Music-Time-Reverse.html#v:rev
[times]: /docs/api/Music-Time-Juxtapose.html#v:times
[sustain]: /docs/api/Music-Time-Juxtapose.html#v:sustain
[anticipate]: /docs/api/Music-Time-Juxtapose.html#v:anticipate
[repeated]: /docs/api/Music-Time-Juxtapose.html#v:repeated
[invertAround]: /docs/api/Music-Score-Pitch.html#v:invertAround
[Score]: /docs/api/Music-Score-Export-Lilypond.html#t:Score
[Voice]: /docs/api/Music-Score-Voice.html#t:Voice
[Track]: /docs/api/Music-Score-Track.html#t:Track
[Delayable]: /docs/api/Music-Time-Delayable.html#t:Delayable
[Stretchable]: /docs/api/Music-Time-Stretchable.html#t:Stretchable
[setClef]: /docs/api/Music-Score-Meta.html#v:setClef
[setClefDuring]: /docs/api/Music-Score-Meta.html#v:setClefDuring

<!-- Unknown: readMidi No such identifier: readMidi-->

[writeMidi]: /docs/api/Music-Score-Export-Midi.html#v:writeMidi
[playMidi]: /docs/api/Music-Score-Export-Midi.html#v:playMidi
[playMidiIO]: /docs/api/Music-Score-Export-Midi.html#v:playMidiIO

[Lilypond]:         http://lilypond.org
[Timidity]:         http://timidity.sourceforge.net/
[HaskellPlatform]:  http://www.haskell.org/platform/

[issue-tracker]:    https://github.com/hanshoglund/music-score/issues

[pandoc]:           http://johnmacfarlane.net/pandoc/
[haskell-suite]:    https://github.com/haskell-suite
[music-util-docs]:  https://github.com/hanshoglund/music-util/blob/master/README.md#music-util

[common-music]:     http://commonmusic.sourceforge.net/
[temporal-media]:   http://hackage.haskell.org/package/temporal-media
[abjad]:            https://pypi.python.org/pypi/Abjad/2.3
[max-msp]:          http://cycling74.com/products/max/
[reactive]:         http://www.haskell.org/haskellwiki/Reactive
[diagrams]:         http://projects.haskell.org/diagrams/
[supercollider]:    http://supercollider.sourceforge.net/
[music21]:          http://music21-mit.blogspot.se/
[guido]:            http://guidolib.sourceforge.net/
[lilypond]:         http://lilypond.org/
[fomus]:            http://fomus.sourceforge.net/
[haskore]:          http://www.haskell.org/haskellwiki/Haskore
[euterpea]:         http://haskell.cs.yale.edu/euterpea/
[haskell]:          http://haskell.org
[pandoc]:           http://johnmacfarlane.net/pandoc/





