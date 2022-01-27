use PDF::Font::Loader;

unit class PDF::Font::Loader::CSS:ver<0.0.1>
    is PDF::Font::Loader;

use CSS::Font;
use CSS::Font::Descriptor;
use CSS::Font::Resources;
use CSS::Font::Resources::Source;
use PDF::Content::Font::CoreFont;
use URI;

my constant Resources = CSS::Font::Resources;
my constant Source = CSS::Font::Resources::Source;

has CSS::Font::Descriptor @.font-face;
has URI() $.base-url is rw = './';
has Str $.font-family = 'serif'; # default font family
has Bool $.core-font-fallback; # fallback to system fonts

method source(CSS::Font:D :$font! --> Source) {
    my $fallback = ! $.core-font-fallback;
    Resources.source: :$font, :$!base-url, :@!font-face, :$!font-family, :formats('opentype'|'truetype'|'postscript'|'cff'), :$fallback;
}

method core-font(CSS::Font:D() $font) {
    my Str:D $family = $font.family.head // $!font-family;
    my Str() $weight = $font.weight;
    my Str() $style  = $font.style;

    given PDF::Content::Font::CoreFont {
        .load-font($family, :$weight, :$style)
        // .load-font('helvetica', :$weight, :$style)
    }
}

multi method load-font(CSS::Font:D() :$font!, |c) {
    do with self.find-font(:$font, |c) -> $file {
        self.load-font: :$file, |c;
    } // self.core-font($font);
}

multi method find-font(CSS::Font:D() :$font!, Source :$source = $.source(:$font)) {
    .IO.path with $source;
}
multi method find-font($?: |) { nextsame; }
