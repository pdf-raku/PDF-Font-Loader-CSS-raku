use Test;
plan 14;
use CSS::Font::Descriptor;
use PDF::Font::Manager;
use PDF::Font::Loader::FontObj;
use PDF::Content::FontObj;

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

for (False, True) -> $core-font-fallback {
    my PDF::Font::Manager $font-loader .= new: :@font-face, :base-url<t/>, :$core-font-fallback;

    my Str $font = $font-loader.find-font: :font("bold italic 12pt DejaVu Sans");
    is $font, 't/fonts/DejaVuSans-BoldOblique.ttf';
    my PDF::Content::FontObj $font-obj = $font-loader.load-font: :font("bold italic 12pt DejaVu Sans");
    ok $font-obj.defined;
    isa-ok $font-obj, "PDF::Font::Loader::FontObj";
    is $font-obj.font-name, "DejaVuSans-BoldOblique";

    my $class = $core-font-fallback ?? 'PDF::Content::Font::CoreFont' !! 'PDF::Font::Loader::FontObj';
    $font-obj = $font-loader.load-font: :font("bold italic 12pt Times-Roman");
    isa-ok $font-obj, $class, "load-font() {$core-font-fallback ?? 'with' !! 'without'} core-font fallback";
    if $core-font-fallback {
        is $font-obj.font-name, 'Times-Italic', 'core-font name';
    }

    $font-obj = $font-loader.load-font: :font("bold italic 12pt Misc");
    isa-ok $font-obj, $class, "load-font() {$core-font-fallback ?? 'with' !! 'without'} core-font fallback";
    if $core-font-fallback {
        is $font-obj.font-name, 'Helvetica-Oblique', 'core-font name';
    }
}
