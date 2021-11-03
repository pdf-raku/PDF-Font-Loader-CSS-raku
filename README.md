## Name

PDF::Font::Loader::CSS

## Synopsis

```raku
use CSS::Stylesheet;
use PDF::Font::Loader::FontObj;
use PDF::Font::Loader::CSS;

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

my PDF::Font::Loader::CSS $font-loader .= new: :@font-face, :base-url<t/>;

my CSS::Font() $font = "bold italic 12pt DejaVu Sans";
say $font-loader.find-font(:$font); # t/fonts/DejaVuSans-BoldOblique.ttf';
my PDF::Loader::FontObj $font-obj = $font-loader.load-font: :$font;
say $font-obj.font-name; # DejaVuSans-BoldOblique;
```

## Description

This module extends PDF::Font::Loader, adding `@font-face` attributes and rules to enable CSS
compatible font selection.

In particular, it extends the `find-font()` and `load-font()` methods; adding multi candidates to select
from a list of `@font-face` font descriptors.

## Methods

### find-font

    multi method find-font( CSS::Font:D() :$font) returns Str

Returns a matching font file name. This will either been a local file, or
a temporary file, fetched from a remote URI.

### load-font

    multi method load-font( CSS::Font:D() :$font) returns Font::Loader::FontObj

Returns a matching font file name. This will either been a local file, or
a temporary file, fetched from a remote URI.

### source

   method source CSS::Font:D() :$font() returns CSS::Font::Resources::Source

Returns a matching source for the font. This is the first matching font of an acceptable
PDF format (`opentype`, `truetype`, `postscript`, or `cff`).
