use strict;
use warnings;

use Symbol;
use Test::More tests => 4;

BEGIN {
    use_ok( 'CommonMark::GFM', ':opt', ':list', ':delim' );
}

my $doc = CommonMark::GFM->create_document(
    children => [
        CommonMark::GFM->create_header(
            level    => 2,
            children => [
                CommonMark::GFM->create_text(
                    literal => 'Header',
                ),
            ],
        ),
        CommonMark::GFM->create_block_quote(
            children => [
                CommonMark::GFM->create_paragraph(
                    text => 'Block quote',
                ),
            ],
        ),
        CommonMark::GFM->create_list(
            type     => ORDERED_LIST,
            delim    => PAREN_DELIM,
            start    => 2,
            tight    => 1,
            children => [
                CommonMark::GFM->create_item(
                    children => [
                        CommonMark::GFM->create_paragraph(
                            text => 'Item 1',
                        ),
                    ],
                ),
                CommonMark::GFM->create_item(
                    children => [
                        CommonMark::GFM->create_paragraph(
                            text => 'Item 2',
                        ),
                    ],
                ),
            ],
        ),
        CommonMark::GFM->create_code_block(
            literal => 'Code block',
        ),
        CommonMark::GFM->create_html(
            literal => '<div>html</html>',
        ),
        CommonMark::GFM->create_hrule,
        CommonMark::GFM->create_paragraph(
            children => [
                CommonMark::GFM->create_emph(
                    children => [
                        CommonMark::GFM->create_text(
                            literal => 'emph',
                        ),
                    ],
                ),
                CommonMark::GFM->create_softbreak,
                CommonMark::GFM->create_link(
                    url      => '/url',
                    title    => 'link title',
                    children => [
                        CommonMark::GFM->create_strong(
                            text => 'link text',
                        ),
                    ],
                ),
                CommonMark::GFM->create_linebreak,
                CommonMark::GFM->create_image(
                    url   => '/facepalm.jpg',
                    title => 'image title',
                    text  => 'alt text',
                ),
                CommonMark::GFM->create_linebreak,
                CommonMark::GFM->create_code(
                    literal => 'code',
                ),
                CommonMark::GFM->create_linebreak,
                CommonMark::GFM->create_html_inline(
                    literal => '<s>html1</s>',
                ),
                CommonMark::GFM->create_inline_html(
                    literal => '<s>html2</s>',
                ),
            ],
        ),
    ],
);

my $expected_html = <<'EOF';
<h2>Header</h2>
<blockquote>
<p>Block quote</p>
</blockquote>
<ol start="2">
<li>Item 1</li>
<li>Item 2</li>
</ol>
<pre><code>Code block</code></pre>
<div>html</html>
<hr />
<p><em>emph</em>
<a href="/url" title="link title"><strong>link text</strong></a><br />
<img src="/facepalm.jpg" alt="alt text" title="image title" /><br />
<code>code</code><br />
<s>html1</s><s>html2</s></p>
EOF
is( $doc->render_html(OPT_UNSAFE), $expected_html, 'create_* helpers' );

$doc = CommonMark::GFM->create_document(
    children => [
        CommonMark::GFM->create_custom_block(
            on_enter => '<div class="custom">',
            on_exit  => '</div>',
            children => [
                CommonMark::GFM->create_paragraph(
                    children => [
                        CommonMark::GFM->create_custom_inline(
                            on_enter => '<span class="custom">',
                            on_exit  => '</span>',
                            text     => 'foo',
                        ),
                    ],
                ),
            ],
        ),
    ],
);

$expected_html = <<'EOF';
<div class="custom">
<p><span class="custom">foo</span></p>
</div>
EOF

is( $doc->render_html, $expected_html, 'create_custom_* helpers' );

$doc = CommonMark::GFM->create_document(
    children => [
        CommonMark::GFM->create_code_block(
            fence_info => 'perl',
            literal    => 'my @a = qw(1 2 3);',
        ),
    ]
);

$expected_html = <<'EOF';
<pre><code class="language-perl">my @a = qw(1 2 3);</code></pre>
EOF

is( $doc->render_html, $expected_html, 'create_custom_* helpers' );
