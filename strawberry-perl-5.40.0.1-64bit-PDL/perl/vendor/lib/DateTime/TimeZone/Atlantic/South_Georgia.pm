# This file is auto-generated by the Perl DateTime Suite time zone
# code generator (0.08) This code generator comes with the
# DateTime::TimeZone module distribution in the tools/ directory

#
# Generated from /tmp/S2_G3OrWui/southamerica.  Olson data version 2024a
#
# Do not edit this file directly.
#
package DateTime::TimeZone::Atlantic::South_Georgia;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '2.62';

use Class::Singleton 1.03;
use DateTime::TimeZone;
use DateTime::TimeZone::OlsonDB;

@DateTime::TimeZone::Atlantic::South_Georgia::ISA = ( 'Class::Singleton', 'DateTime::TimeZone' );

my $spans =
[
    [
DateTime::TimeZone::NEG_INFINITY, #    utc_start
59611170368, #      utc_end 1890-01-01 02:26:08 (Wed)
DateTime::TimeZone::NEG_INFINITY, #  local_start
59611161600, #    local_end 1890-01-01 00:00:00 (Wed)
-8768,
0,
'LMT',
    ],
    [
59611170368, #    utc_start 1890-01-01 02:26:08 (Wed)
DateTime::TimeZone::INFINITY, #      utc_end
59611163168, #  local_start 1890-01-01 00:26:08 (Wed)
DateTime::TimeZone::INFINITY, #    local_end
-7200,
0,
'-02',
    ],
];

sub olson_version {'2024a'}

sub has_dst_changes {0}

sub _max_year {2034}

sub _new_instance {
    return shift->_init( @_, spans => $spans );
}



1;

