## Name

PDF::Font::Manager

## Synopsis

```raku
use CSS::Stylesheet;
use PDF::Font::Loader::FontObj;
use PDF::Font::Manager;

my CSS::Stylesheet $css .= parse: q:to<END>;
    @font-face {
        font-family: "DejaVu Sans";
        src: url("fonts/DejaVuSans.ttf");
    }
    @font-face {
        font-family: "DejaVu Sans";
        src: url("fonts/DejaVuSans-Bold.ttf");
        font-weight: bold;
    }
    @font-face {
        font-family: "DejaVu Sans";
        src: url("fonts/DejaVuSans-Oblique.ttf");
        font-style: oblique;
    }
    @font-face {
        font-family: "DejaVu Sans";
        src: url("fonts/DejaVuSans-BoldOblique.ttf");
        font-weight: bold;
        font-style: oblique;
    }
    END

my CSS::Font::Descriptor @font-face = $css.font-face;

my PDF::Font::Manager $font-loader .= new: :@font-face, :base-url<t/>;

my CSS::Font() $font = "bold italic 12pt DejaVu Sans";
say $font-loader.find-font(:$font); # t/fonts/DejaVuSans-BoldOblique.ttf';
my PDF::Loader::FontObj $font-obj = $font-loader.load-font: :$font;
say $font-obj.font-name; # DejaVuSans-BoldOblique;
```

## Description

This is based on PDF::Font::Loader, but adds the ability to load and manage fonts
via `@font-face` CSS font descriptor declaration.

In particular, it extends the `find-font()` and `load-font()` methods; adding multi candidates to
handle CSS font properties and select from a list of `@font-face` font descriptors.

## Methods

### find-font

    multi method find-font( CSS::Font:D() :$font) returns Str

Returns a matching font file name. This will either been a local file, or
a temporary file, fetched from a remote URI.

### load-font

    multi method load-font( CSS::Font:D() :$font, Bool :$core-font-fallback) returns Font::Loader::FontObj

Finds and loads a matching font object.

If none of the `@font-face` rules were matched:

- if `:$core-font-fallback` is True, the best matching core font is returned as a `PDF::Content::CoreFont` object.
- otherwise the best matching system font is found, and returned as a `PDF::FontLoader::FontObj` object.

Note: If you don't have `fontconfig` and the `fc-match` command installed on your system, `:$core-font-font-fallback` should be set to True to disable `fontconfig`.

### source

    method source CSS::Font:D() :$font() returns CSS::Font::Resources::Source

Returns a matching source for the font. This is the first matching font of an acceptable
PDF format (`opentype`, `truetype`, `postscript`, or `cff`).
