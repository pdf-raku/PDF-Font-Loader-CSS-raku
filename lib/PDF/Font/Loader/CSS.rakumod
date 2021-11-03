use PDF::Font::Loader;

unit class PDF::Font::Loader::CSS
    is PDF::Font::Loader;

use CSS::Font;
use CSS::Font::Descriptor;
use CSS::Font::Resources;
use CSS::Font::Resources::Source;
use URI;

my constant Resources = CSS::Font::Resources;
my constant Source = CSS::Font::Resources::Source;

has CSS::Font::Descriptor @.font-face;
has URI() $.base-url = './';

method source(CSS::Font:D :$font! --> Source) {
    Resources.source: :$font, :$!base-url, :@!font-face, :formats('opentype'|'truetype'|'postscript'|'cff');
}

multi method load-font(CSS::Font:D() :$font!, |c) {
    my $file = self.find-font: :$font, |c;
    self.load-font: :$file, |c;
}

multi method find-font(CSS::Font:D() :$font!, Source :$source = $.source(:$font)) {
    .IO.path with $source;
}
multi method find-font($?: |) { nextsame; }
