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

has Hash:D $.cache = %();
has CSS::Font::Descriptor @.font-face;
has URI() $.base-url = './';

multi method load-font(CSS::Font:D() :$font!) {
    my $file = self.find-font: :$font;
    self.load-font: :$file,
}

multi method find-font(CSS::Font:D() :$font!) {
    my Source $source = .head
        with Resources.sources(:$font, :$!base-url, :@!font-face, :formats('opentype'|'truetype'|'postscript'|'cff'));
    my $key = do with $source { .Str } else { '' };
    my PDF::Content::FontObj $font-obj;
    $!cache{$key} //= .IO.path
        with $source;
}
multi method find-font($?: |) { nextsame; }
