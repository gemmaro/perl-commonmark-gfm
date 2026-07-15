use strict;
use warnings;

use Test::More tests => 2;

use CommonMark::GFM qw(:opt);

use constant SOURCE => <<END_GFM;
a b[^1] c

[^1]: d
END_GFM

use utf8;

my $parser = CommonMark::GFM::Parser->new;
$parser->feed(SOURCE);
my $doc = $parser->finish;
my $expected_html = <<'EOF';
<p>a b<a href="d">^1</a> c</p>
EOF
is( $doc->render_html, $expected_html, 'parser works when disabled' );

$parser = CommonMark::GFM::Parser->new(CommonMark::GFM::OPT_FOOTNOTES);
$parser->feed(SOURCE);
$doc = $parser->finish;
$expected_html = <<'EOF';
<p>a b<sup class="footnote-ref"><a href="#fn-1" id="fnref-1" data-footnote-ref>1</a></sup> c</p>
<section class="footnotes" data-footnotes>
<ol>
<li id="fn-1">
<p>d <a href="#fnref-1" class="footnote-backref" data-footnote-backref data-footnote-backref-idx="1" aria-label="Back to reference 1">↩</a></p>
</li>
</ol>
</section>
EOF
is( $doc->render_html, $expected_html, 'parser works when enabled' );
