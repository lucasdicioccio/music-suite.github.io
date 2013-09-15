

## The Music Suite

<!--
> *Please note:* The API and docs are not particularly stable at the moment. An official release note will appear in due time.
-->

The Music Suite is a declarative language embedded in [Haskell][Haskell] for generation and manipulation of music.<!-- It is is similar to [Haskore][Haskore] and [Euterpea][Euterpea], but its design and general philosophy is more inspired by [Diagrams][Diagrams] and [Reactive][Reactive]. -->

The Music Suite was designed with the dual goal of:

* Being usable with all *theories of music*. In particular, it does *not* assume a Western classical notion of time and pitch.

* Include Western classical music theory as a *special case*. Conventional scores can be represented in full, with correct part structure, pitch, rhythm, dynamics, articulation and so on. Many function are generalized to work on any music representation.


### An example

To generate music we write an *expressions* such as this one:

<div class='haskell-music'>



![](4ea6815a58473e70x.png)

```haskell
let
    m = staccato (scat [c,d,e,c]^/2) |> ab |> b_ |> legato (d |> c)^*2
in stretch (1/8) m

```

</div>

To transform music, we write a *function*. For example the following function halves all durations and transposes all pitches up a minor sixth:

```haskell
up (minor sixth) . compress 2

```

Applied to the above music we get:



![](1dfd7766e2c33bbex.png)

### Input and output

The Music Suite works well with the following input and output formats:

* MusicXML
* Lilypond
* ABC notation
* Midi

### More information

For a complete reference, see the [API documentation](/docs/api).

<!--
For an introduction, see [User Guide](User-Guide).
-->

[Haskell]:      http://www.haskell.org/haskellwiki/Haskell
[Haskore]:      http://www.haskell.org/haskellwiki/Haskore
[Euterpea]:     http://haskell.cs.yale.edu/euterpea
[Diagrams]:     http://projects.haskell.org/diagrams
[Reactive]:     http://hackage.haskell.org/package/reactive





