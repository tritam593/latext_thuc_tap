#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::IO::Storable;

our @EXPORT_OK = qw();
our %EXPORT_TAGS = (Func=>\@EXPORT_OK);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;


   
   our @ISA = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::IO::Storable ;











#line 1 "storable.pd"

=head1 NAME

PDL::IO::Storable - helper functions to make PDL usable with Storable

=head1 SYNOPSIS

  use Storable;
  use PDL::IO::Storable;
  $hash = {
            'foo' => 42,
            'bar' => zeroes(23,45),
          };
  store $hash, 'perlhash.dat';

=head1 DESCRIPTION

C<Storable> implements object persistence for Perl data structures that can
contain arbitrary Perl objects. This module implements the relevant methods to
be able to store and retrieve ndarrays via Storable.

=head1 FUNCTIONS

=cut

use strict;
use warnings;

#line 65 "storable.pd"
{ package # hide from PAUSE
    PDL;
use Carp;
# routines to make PDL work with Storable >= 1.03

# pdlpack() serializes an ndarray, while pdlunpack() unserializes it. Earlier
# versions of PDL didn't control for endianness, type sizes and enumerated type
# values; this made stored data unportable across different architectures and
# PDL versions. This is no longer the case, but the reading code is still able
# to read the old files. The old files have no meta-information in them so it's
# impossible to read them correctly with 100% accuracy, but we try to make an
# educated guess
#
# Old data format:
#
#  int type
#  int ndims
#  int dims[ndims]
#  data
#
# Note that here all the sizes and endiannesses are the native. This is
# un-portable. Furthermore, the "type" is an enum, and its values could change
# between PDL versions. Here I assume that the old format input data is indeed
# native, so the old data files have the same portability issues, but at least
# things will remain working and broken in the same way they were before
#
#
# New format:
#
#  uint64 0xFFFF FFFF FFFF FFFF # meant to be different from the old-style data
#  char type[16]                # ' '-padded, left-aligned type string such as 'PDL_LL'
#  uint32 sizeof(type)          # little-endian
#  uint32 one                   # native-endian. Used to determine the endianness
#  uint64 ndims                 # little-endian
#  uint64 dims[ndims]           # little-endian
#  data
#
# The header data is all little-endian here. The data is stored with native
# endianness. On load it is checked, and a swap happens, if it is required

sub pdlpack {
  my ($pdl) = @_;

  my $hdr = pack( 'c8A16VL',
                  (-1) x 8,
                  $pdl->type->symbol,
                  PDL::Core::howbig( $pdl->get_datatype ), 1 );

  # I'd like this to be simply
  #   my $dimhdr = pack( 'Q<*', $pdl->getndims, $pdl->dims )
  # but my pack() may not support Q, so I break it up manually
  #
  # if sizeof(int) == 4 here, then $_>>32 will not return 0 necessarily (this in
  # undefined). I thus manually make sure this is the case
  #
  my $noMSW = (PDL::Core::howbig($PDL::Types::PDL_IND) < 8) ? 1 : 0;
  my $dimhdr = pack( 'V*',
                     map( { $_ & 0xFFFFFFFF, $noMSW ? 0 : ($_ >> 32) } ($pdl->getndims, $pdl->dims ) ) );

  my $dref = $pdl->get_dataref;
  return $hdr . $dimhdr . $$dref;
}

sub pdlunpack {
  use Config ();
  my ($pdl,$pack) = @_;

  my ($type, $ndims);
  my @dims = ();

  my $do_swap = 0;

  # first I try to infer the type of this storable
  my $offset = 0;
  my @magicheader = unpack( "ll", substr( $pack, $offset ) );
  $offset += 8;

  if( $magicheader[0] != -1 ||
      $magicheader[1] != -1 )
  {
    print "PDL::IO::Storable detected an old-style pdl\n" if $PDL::verbose;

    # old-style data. I leave the data sizes, endianness native, since I don't
    # know any better. This at least won't break anything.
    #
    # The "type" however needs attention. Most-recent old-format data had these
    # values for the type:
    #
    #  enum { byte,
    #         short,
    #         unsigned short,
    #         long,
    #         long long,
    #         float,
    #         double }
    #
    # The $type I read from the file is assumed to be in this enum even though
    # PDL may have added other types in the middle of this enum.
    my @reftypes = ($PDL::Types::PDL_B,
                    $PDL::Types::PDL_S,
                    $PDL::Types::PDL_U,
                    $PDL::Types::PDL_L,
                    $PDL::Types::PDL_LL,
                    $PDL::Types::PDL_F,
                    $PDL::Types::PDL_D);

    my $stride = $Config::Config{intsize};
    ($type,$ndims) = unpack 'i2', $pack;
    @dims = $ndims > 0 ? unpack 'i*', substr $pack, 2*$stride,
      $ndims*$stride : ();

    $offset = (2+$ndims)*$stride;

    if( $type < 0 || $type >= @reftypes )
    {
      croak "Reading in old-style pdl with unknown type: $type. Giving up.";
    }
    $type = $reftypes[$type];
  }
  else
  {
    print "PDL::IO::Storable detected a new-style pdl\n" if $PDL::verbose;

    # new-style data. I KNOW the data sizes, endianness and the type enum
    my ($typestring) = unpack( 'A16', substr( $pack, $offset ) );
    $offset += 16;

    $type = eval( '$PDL::Types::' . $typestring );
    if( $@ )
    {
      croak "PDL::IO::Storable couldn't parse type string '$typestring'. Giving up";
    }

    my ($sizeof) = unpack( 'V', substr( $pack, $offset ) );
    $offset += 4;
    if( $sizeof != PDL::Core::howbig( $type ) )
    {
      croak
        "PDL::IO::Storable sees mismatched data type sizes when reading data of type '$typestring'\n" .
        "Stored data has sizeof = $sizeof, while here it is " . PDL::Core::howbig( $type ) . ".\n" .
        "Giving up";
    }

    # check the endianness, if the "1" I read is interpreted as "1" on my
    # machine then the endiannesses match, and I can just read the data
    my ($one) = unpack( 'L', substr( $pack, $offset ) );
    $offset += 4;

    if( $one == 1 )
    {
      print "PDL::IO::Storable detected matching endianness\n" if $PDL::verbose;
    }
    else
    {
      print "PDL::IO::Storable detected non-matching endianness. Correcting data on load\n" if $PDL::verbose;

      # mismatched endianness. Let's make sure it's a big/little issue, not
      # something weird. If mismatched, the '00000001' should be seen as
      # '01000000'
      if( $one != 0x01000000 )
      {
        croak
          "PDL::IO::Storable sees confused endianness. A '1' was read as '$one'.\n" .
          "This is neither matching nor swapped endianness. I don't know what's going on,\n" .
          "so I'm giving up."
      }

      # all righty. Everything's fine, but I need to swap all the data
      $do_swap = 1;
    }

    # mostly this acts like unpack('Q<'...), but works even if my unpack()
    # doesn't support 'Q'. This also makes sure that my PDL_Indx is large enough
    # to read this ndarray
    sub unpack64bit
    {
      my ($count, $pack, $offset) = @_;

      return map
      {
        my ($lsw, $msw) = unpack('VV', substr($$pack, $$offset));
        $$offset += 8;

        croak( "PDL::IO::Storable tried reading a file with dimensions that don't fit into 32 bits.\n" .
               "However here PDL_Indx can't store a number so large. Giving up." )
          if( PDL::Core::howbig($PDL::Types::PDL_IND) < 8 && $msw != 0 );

        (($msw << 32) | $lsw)
      } (1..$count);
    }

    ($ndims) = unpack64bit( 1, \$pack, \$offset );
    @dims = unpack64bit( $ndims, \$pack, \$offset ) if $ndims > 0;
  }

  print "thawing PDL, Dims: [",join(',',@dims),"]\n" if $PDL::verbose;
  $pdl->make_null; # make this a real ndarray -- this is the tricky bit!
  $pdl->set_datatype($type);
  $pdl->setdims([@dims]);
  my $dref = $pdl->get_dataref;

  $$dref = substr $pack, $offset;
  if( $do_swap && PDL::Core::howbig( $type ) != 1 )
  {
    swapEndian( $$dref, PDL::Core::howbig( $type ) );
  }
  $pdl->upd_data;
  return $pdl;
}

sub STORABLE_freeze {
  my ($self, $cloning) = @_;
#  return if $cloning;         # Regular default serialization
  return UNIVERSAL::isa($self, "HASH") ? ("",{%$self}) # hash ref -> Storable
    : (pdlpack $self); # pack the ndarray into a long string
}

sub STORABLE_thaw {
  my ($pdl,$cloning,$serial,$hashref) = @_;
  # print "in STORABLE_thaw\n";
#  return if $cloning;
  my $class = ref $pdl;
  if (defined $hashref) {
    croak "serial data with hashref!" unless ($serial//'') eq "";
    @$pdl{keys %$hashref} = values %$hashref;
  } else {
    # all the magic is happening in pdlunpack
    $pdl->pdlunpack($serial); # unpack our serial into this sv
  }
}

# have these as PDL methods

=head2 store

=for ref

store an ndarray using L<Storable>

=for example

  $x = random 12,10;
  $x->store('myfile');

=cut

=head2 freeze

=for ref

freeze an ndarray using L<Storable>

=for example

  $x = random 12,10;
  $frozen = $x->freeze;

=cut

sub store  { require Storable; Storable::store(@_) }
sub freeze { require Storable; Storable::freeze(@_) }
}

=head1 AUTHOR

Copyright (C) 2013 Dima Kogan <dima@secretsauce.net>
Copyright (C) 2002 Christian Soeller <c.soeller@auckland.ac.nz>
All rights reserved. There is no warranty. You are allowed
to redistribute this software / documentation under certain
conditions. For details, see the file COPYING in the PDL
distribution. If this file is separated from the PDL distribution,
the copyright notice should be included in the file.

=cut
#line 334 "Storable.pm"

# Exit with OK status

1;
