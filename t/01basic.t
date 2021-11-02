use Test;
plan 4;
use CSS::Font::Descriptor;
use PDF::Font::Loader::CSS;
use PDF::Font::Loader::FontObj;

my @decls = q:to<END>.split(/^^'---'$$/);
        font-family: "DejaVu Sans";
        src: url("fonts/DejaVuSans.ttf");
        ---
        font-family: "DejaVu Sans";
        src: url("fonts/DejaVuSans-Bold.ttf");
        font-weight: bold;
        ---
        font-family: "DejaVu Sans";
        src: url("fonts/DejaVuSans-Oblique.ttf");
        font-style: oblique;
        ---
        font-family: "DejaVu Sans";
        src: url("fonts/DejaVuSans-BoldOblique.ttf");
        font-weight: bold;
        font-style: oblique;
        END

my CSS::Font::Descriptor @font-face = @decls.map: -> $style {CSS::Font::Descriptor.new: :$style};

my PDF::Font::Loader::CSS $font-loader .= new: :@font-face, :base-url<t/>;

my Str $font = $font-loader.find-font: :font("bold italic 12pt DejaVu Sans");
is $font, 't/fonts/DejaVuSans-BoldOblique.ttf';
my $font-obj = $font-loader.load-font: :font("bold italic 12pt DejaVu Sans");
ok $font-obj.defined;
isa-ok $font-obj, "PDF::Font::Loader::FontObj";
is $font-obj.font-name, "DejaVuSans-BoldOblique";
