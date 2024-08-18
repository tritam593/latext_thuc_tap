# This file is auto-generated by the Perl DateTime Suite time zone
# code generator (0.08) This code generator comes with the
# DateTime::TimeZone module distribution in the tools/ directory

#
# Generated from /tmp/S2_G3OrWui/australasia.  Olson data version 2024a
#
# Do not edit this file directly.
#
package DateTime::TimeZone::Pacific::Kwajalein;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '2.62';

use Class::Singleton 1.03;
use DateTime::TimeZone;
use DateTime::TimeZone::OlsonDB;

@DateTime::TimeZone::Pacific::Kwajalein::ISA = ( 'Class::Singleton', 'DateTime::TimeZone' );

my $spans =
[
    [
DateTime::TimeZone::NEG_INFINITY, #    utc_start
59958190240, #      utc_end 1900-12-31 12:50:40 (Mon)
DateTime::TimeZone::NEG_INFINITY, #  local_start
59958230400, #    local_end 1901-01-01 00:00:00 (Tue)
40160,
0,
'LMT',
    ],
    [
59958190240, #    utc_start 1900-12-31 12:50:40 (Mon)
61094264400, #      utc_end 1936-12-31 13:00:00 (Thu)
59958229840, #  local_start 1900-12-31 23:50:40 (Mon)
61094304000, #    local_end 1937-01-01 00:00:00 (Fri)
39600,
0,
'+11',
    ],
    [
61094264400, #    utc_start 1936-12-31 13:00:00 (Thu)
61228274400, #      utc_end 1941-03-31 14:00:00 (Mon)
61094300400, #  local_start 1936-12-31 23:00:00 (Thu)
61228310400, #    local_end 1941-04-01 00:00:00 (Tue)
36000,
0,
'+10',
    ],
    [
61228274400, #    utc_start 1941-03-31 14:00:00 (Mon)
61318220400, #      utc_end 1944-02-05 15:00:00 (Sat)
61228306800, #  local_start 1941-03-31 23:00:00 (Mon)
61318252800, #    local_end 1944-02-06 00:00:00 (Sun)
32400,
0,
'+09',
    ],
    [
61318220400, #    utc_start 1944-02-05 15:00:00 (Sat)
62127694800, #      utc_end 1969-09-30 13:00:00 (Tue)
61318260000, #  local_start 1944-02-06 02:00:00 (Sun)
62127734400, #    local_end 1969-10-01 00:00:00 (Wed)
39600,
0,
'+11',
    ],
    [
62127694800, #    utc_start 1969-09-30 13:00:00 (Tue)
62881617600, #      utc_end 1993-08-21 12:00:00 (Sat)
62127651600, #  local_start 1969-09-30 01:00:00 (Tue)
62881574400, #    local_end 1993-08-21 00:00:00 (Sat)
-43200,
0,
'-12',
    ],
    [
62881617600, #    utc_start 1993-08-21 12:00:00 (Sat)
DateTime::TimeZone::INFINITY, #      utc_end
62881660800, #  local_start 1993-08-22 00:00:00 (Sun)
DateTime::TimeZone::INFINITY, #    local_end
43200,
0,
'+12',
    ],
];

sub olson_version {'2024a'}

sub has_dst_changes {0}

sub _max_year {2034}

sub _new_instance {
    return shift->_init( @_, spans => $spans );
}



1;

