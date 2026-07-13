use strict;
use warnings;

use Test::More tests => 3;

BEGIN {
    use_ok('CommonMark::GFM');
}

is(
    CommonMark::GFM->version,
    CommonMark::GFM->compile_time_version,
    'version matches compile_time_version'
);
is(
    CommonMark::GFM->version_string,
    CommonMark::GFM->compile_time_version_string,
    'version_string matches compile_time_version_string'
);

