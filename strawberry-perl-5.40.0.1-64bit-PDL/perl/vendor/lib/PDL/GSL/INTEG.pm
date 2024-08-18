#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::GSL::INTEG;

our @EXPORT_OK = qw(gslinteg_qng gslinteg_qag gslinteg_qags gslinteg_qagp gslinteg_qagi gslinteg_qagiu gslinteg_qagil gslinteg_qawc gslinteg_qaws gslinteg_qawo gslinteg_qawf );
our %EXPORT_TAGS = (Func=>\@EXPORT_OK);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;


   
   our @ISA = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::GSL::INTEG ;







#line 6 "gsl_integ.pd"

use strict;
use warnings;

=head1 NAME

PDL::GSL::INTEG - PDL interface to numerical integration routines in GSL

=head1 DESCRIPTION

This is an interface to the numerical integration package present in the
GNU Scientific Library, which is an implementation of QUADPACK.

Functions are named B<gslinteg_{algorithm}> where {algorithm}
is the QUADPACK naming convention. The available functions are:

=over 3

=item gslinteg_qng: Non-adaptive Gauss-Kronrod integration

=item gslinteg_qag: Adaptive integration

=item gslinteg_qags: Adaptive integration with singularities

=item gslinteg_qagp: Adaptive integration with known singular points

=item gslinteg_qagi: Adaptive integration on infinite interval of the form (-\infty,\infty)

=item gslinteg_qagiu: Adaptive integration on infinite interval of the form (la,\infty)

=item gslinteg_qagil: Adaptive integration on infinite interval of the form (-\infty,lb)

=item gslinteg_qawc: Adaptive integration for Cauchy principal values

=item gslinteg_qaws: Adaptive integration for singular functions

=item gslinteg_qawo: Adaptive integration for oscillatory functions

=item gslinteg_qawf: Adaptive integration for Fourier integrals

=back

Each algorithm computes an approximation to the integral, I,
of the function f(x)w(x), where w(x) is a weight function
(for general integrands w(x)=1). The user provides absolute
and relative error bounds (epsabs,epsrel) which specify
the following accuracy requirement:

|RESULT - I|  <= max(epsabs, epsrel |I|)

The routines will fail to converge if the
error bounds are too stringent, but always return the best
approximation obtained up to that stage

All functions return the result, and estimate of the absolute
error and an error flag (which is zero if there were no problems).
You are responsible for checking for any errors, no warnings are issued
unless the option {Warn => 'y'} is specified in which case
the reason of failure will be printed.

You can nest integrals up to 20 levels. If you find yourself in
the unlikely situation that you need more, you can change the value
of 'max_nested_integrals' in the first line of the file 'FUNC.c'
and recompile.

=head1 NOMENCLATURE

Throughout this documentation we strive to use the same variables that
are present in the original GSL documentation (see L<See
Also|"SEE-ALSO">). Oftentimes those variables are called C<a> and
C<b>. Since good Perl coding practices discourage the use of Perl
variables C<$a> and C<$b>, here we refer to Parameters C<a> and C<b>
as C<$pa> and C<$pb>, respectively, and Limits (of domain or
integration) as C<$la> and C<$lb>.

=head1 SYNOPSIS

   use PDL;
   use PDL::GSL::INTEG;

   my $la = 1.2;
   my $lb = 3.7;
   my $epsrel = 0;
   my $epsabs = 1e-6;

   # Non adaptive integration
   my ($res,$abserr,$ierr,$neval) = gslinteg_qng(\&myf,$la,$lb,$epsrel,$epsabs);
   # Warnings on
   my ($res,$abserr,$ierr,$neval) = gslinteg_qng(\&myf,$la,$lb,$epsrel,$epsabs,{Warn=>'y'});

   # Adaptive integration with warnings on
   my $limit = 1000;
   my $key = 5;
   my ($res,$abserr,$ierr) = gslinteg_qag(\&myf,$la,$lb,$epsrel,
                                     $epsabs,$limit,$key,{Warn=>'y'});

   sub myf{
     my ($x) = @_;
     return exp(-$x**2);
   }
#line 127 "INTEG.pm"


=head1 FUNCTIONS

=cut






=head2 gslinteg_qng

=for sig

  Signature: (a(); b(); epsabs(); epsrel(); int gslwarn();
                   [o] result(); [o] abserr(); int [o] neval(); int [o] ierr();; SV* function)

=for ref

Non-adaptive Gauss-Kronrod integration

This function applies the Gauss-Kronrod 10-point, 21-point, 43-point
and 87-point integration rules in succession until an estimate of the
integral of f over ($la,$lb) is achieved within the desired absolute
and relative error limits, $epsabs and $epsrel.  It is meant for fast
integration of smooth functions. It returns an array with the result,
an estimate of the absolute error, an error flag and the number of
function evaluations performed.

=for usage

Usage:

  ($res,$abserr,$ierr,$neval) = gslinteg_qng($function_ref,$la,$lb,
                                             $epsrel,$epsabs,[{Warn => $warn}]);

=for example

Example:

   my ($res,$abserr,$ierr,$neval) = gslinteg_qng(\&f,0,1,0,1e-9);
   # with warnings on
   my ($res,$abserr,$ierr,$neval) = gslinteg_qng(\&f,0,1,0,1e-9,{Warn => 'y'});

   sub f{
     my ($x) = @_;
     return ($x**2.6)*log(1.0/$x);
   }

=for bad

gslinteg_qng does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.

=cut




sub gslinteg_qng{
  my $opt = ref($_[-1]) eq 'HASH' ? pop @_ : {Warn => 'n'};
  barf 'Usage: gslinteg_qng($function_ref,$la,$lb,$epsabs,$epsrel,[opt])'
	unless (@_ == 5);
  my $warn = $$opt{Warn}=~/y/i ? 1 : 0;
  my ($f,$la,$lb,$epsabs,$epsrel) = @_;
  $_=PDL->null for my ($res,$abserr,$neval,$ierr);
  _gslinteg_qng_int($la,$lb,$epsabs,$epsrel,$warn,$res,$abserr,$neval,$ierr,$f);
  return ($res,$abserr,$ierr,$neval);
}



*gslinteg_qng = \&PDL::GSL::INTEG::gslinteg_qng;






=head2 gslinteg_qag

=for sig

  Signature: (a(); b(); epsabs();epsrel();
	           int limit(); int key(); int n(); int gslwarn();
                   [o] result(); [o] abserr(); int [o] ierr();; SV* function)

=for ref

Adaptive integration

This function applies an integration rule adaptively until an estimate of
the integral of f over ($la,$lb) is achieved within the desired absolute and
relative error limits, $epsabs and $epsrel. On each iteration the adaptive
integration strategy bisects the interval with the largest error estimate;
the maximum number of allowed subdivisions is given by the parameter $limit.
The integration rule is determined by the
value of $key, which has to be one of (1,2,3,4,5,6) and correspond to
the 15, 21, 31, 41, 51 and 61  point Gauss-Kronrod rules respectively.
It returns an array with the result, an estimate of the absolute error
and an error flag.

=for usage

Usage:

  ($res,$abserr,$ierr) = gslinteg_qag($function_ref,$la,$lb,$epsrel,
                                      $epsabs,$limit,$key,[{Warn => $warn}]);

=for example

Example:

  my ($res,$abserr,$ierr) = gslinteg_qag(\&f,0,1,0,1e-10,1000,1);
  # with warnings on
  my ($res,$abserr,$ierr) = gslinteg_qag(\&f,0,1,0,1e-10,1000,1,{Warn => 'y'});

  sub f{
     my ($x) = @_;
     return ($x**2.6)*log(1.0/$x);
   }

=for bad

gslinteg_qag does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.

=cut




sub gslinteg_qag {
   my $opt = ref($_[-1]) eq 'HASH' ? pop @_ : {Warn => 'n'};
   my $warn = $$opt{Warn}=~/y/i ? 1 : 0;
   my ($f,$la,$lb,$epsabs,$epsrel,$limit,$key) = @_;
   barf 'Usage: gslinteg_qag($function_ref,$la,$lb,$epsabs,$epsrel,$limit,$key,[opt]) '
	unless ($#_ == 6);
   $_ = PDL->null for my ($res,$abserr,$ierr);
   _gslinteg_qag_int($la,$lb,$epsabs,$epsrel,$limit,$key,$limit,$warn,$res,$abserr,$ierr,$f);
   return ($res,$abserr,$ierr);
}



*gslinteg_qag = \&PDL::GSL::INTEG::gslinteg_qag;






=head2 gslinteg_qags

=for sig

  Signature: (a(); b(); epsabs(); epsrel();
                   int limit(); int n(); int gslwarn();
                   [o] result(); [o] abserr(); int [o] ierr();; SV* function)

=for ref

Adaptive integration with singularities

This function applies the Gauss-Kronrod 21-point integration rule
adaptively until an estimate of the integral of f over ($la,$lb) is
achieved within the desired absolute and relative error limits,
$epsabs and $epsrel. The algorithm is such that it
accelerates the convergence of the integral in the presence of
discontinuities and integrable singularities.
The maximum number of allowed subdivisions done by the adaptive
algorithm must be supplied in the parameter $limit.

=for usage

Usage:

  ($res,$abserr,$ierr) = gslinteg_qags($function_ref,$la,$lb,$epsrel,
                                       $epsabs,$limit,[{Warn => $warn}]);

=for example

Example:

  my ($res,$abserr,$ierr) = gslinteg_qags(\&f,0,1,0,1e-10,1000);
  # with warnings on
  ($res,$abserr,$ierr) = gslinteg_qags(\&f,0,1,0,1e-10,1000,{Warn => 'y'});

  sub f{
     my ($x) = @_;
     return ($x)*log(1.0/$x);
   }

=for bad

gslinteg_qags does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.

=cut




sub gslinteg_qags{
  my $opt = ref($_[-1]) eq 'HASH' ? pop @_ : {Warn => 'n'};
  my $warn = $$opt{Warn}=~/y/i ? 1 : 0;
  my ($f,$la,$lb,$epsabs,$epsrel,$limit) = @_;
  barf 'Usage: gslinteg_qags($function_ref,$la,$lb,$epsabs,$epsrel,$limit,[opt]) '
	unless ($#_ == 5);
  $_ = PDL->null for my ($res,$abserr,$ierr);
  _gslinteg_qags_int($la,$lb,$epsabs,$epsrel,$limit,$limit,$warn,$res,$abserr,$ierr,$f);
  return ($res,$abserr,$ierr);
}



*gslinteg_qags = \&PDL::GSL::INTEG::gslinteg_qags;






=head2 gslinteg_qagp

=for sig

  Signature: (pts(l); epsabs(); epsrel();int limit();int n();int gslwarn();
		   [o] result(); [o] abserr();int [o] ierr();; SV* function)

=for ref

Adaptive integration with known singular points

This function applies the adaptive integration algorithm used by
gslinteg_qags taking into account the location of singular points
until an estimate of
the integral of f over ($la,$lb) is achieved within the desired absolute and
relative error limits, $epsabs and $epsrel.
Singular points are supplied in the ndarray $points, whose endpoints
determine the integration range.
So, for example, if the function has singular points at x_1 and x_2 and the
integral is desired from a to b (a < x_1 < x_2 < b), $points = pdl(a,x_1,x_2,b).
The maximum number of allowed subdivisions done by the adaptive
algorithm must be supplied in the parameter $limit.

=for usage

Usage:

  ($res,$abserr,$ierr) = gslinteg_qagp($function_ref,$points,$epsabs,
                                       $epsrel,$limit,[{Warn => $warn}])

=for example

Example:

  my $points = pdl(0,1,sqrt(2),3);
  my ($res,$abserr,$ierr) = gslinteg_qagp(\&f,$points,0,1e-3,1000);
  # with warnings on
  ($res,$abserr,$ierr) = gslinteg_qagp(\&f,$points,0,1e-3,1000,{Warn => 'y'});

  sub f{
    my ($x) = @_;
    my $x2 = $x**2;
    my $x3 = $x**3;
    return $x3 * log(abs(($x2-1.0)*($x2-2.0)));
  }

=for bad

gslinteg_qagp does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.

=cut




sub gslinteg_qagp{
  my $opt = ref($_[-1]) eq 'HASH' ? pop @_ : {Warn => 'n'};
  my $warn = $$opt{Warn}=~/y/i ? 1 : 0;
  my ($f,$points,$epsabs,$epsrel,$limit) = @_;
  barf 'Usage: gslinteg_qagp($function_ref,$points,$epsabs,$epsrel,$limit,[opt]) '
	unless ($#_ == 4);
  $_ = PDL->null for my ($res,$abserr,$ierr);
  _gslinteg_qagp_int($points,$epsabs,$epsrel,$limit,$limit,$warn,$res,$abserr,$ierr,$f);
  return ($res,$abserr,$ierr);
}



*gslinteg_qagp = \&PDL::GSL::INTEG::gslinteg_qagp;






=head2 gslinteg_qagi

=for sig

  Signature: (epsabs(); epsrel(); int limit(); int n();int gslwarn();
		   [o] result(); [o] abserr(); int [o] ierr();; SV* function)

=for ref

Adaptive integration on infinite interval

This function estimates the integral of the function f over the
infinite interval (-\infty,+\infty) within the desired absolute and
relative error limits, $epsabs and $epsrel.
After a transformation, the algorithm
of gslinteg_qags with a 15-point Gauss-Kronrod rule is used.
The maximum number of allowed subdivisions done by the adaptive
algorithm must be supplied in the parameter $limit.

=for usage

Usage:

  ($res,$abserr,$ierr) = gslinteg_qagi($function_ref,$epsabs,
                                       $epsrel,$limit,[{Warn => $warn}]);

=for example

Example:

  my ($res,$abserr,$ierr) = gslinteg_qagi(\&myfn,1e-7,0,1000);
  # with warnings on
  ($res,$abserr,$ierr) = gslinteg_qagi(\&myfn,1e-7,0,1000,{Warn => 'y'});

  sub myfn{
    my ($x) = @_;
    return exp(-$x - $x*$x) ;
  }

=for bad

gslinteg_qagi does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.

=cut




sub gslinteg_qagi {
  my $opt = ref($_[-1]) eq 'HASH' ? pop @_ : {Warn => 'n'};
  my $warn = $$opt{Warn}=~/y/i ? 1 : 0;
  my ($f,$epsabs,$epsrel,$limit) = @_;
  barf 'Usage: gslinteg_qagi($function_ref,$epsabs,$epsrel,$limit,[opt])'
	unless ($#_ == 3);
  $_ = PDL->null for my ($res,$abserr,$ierr);
  _gslinteg_qagi_int($epsabs,$epsrel,$limit,$limit,$warn,$res,$abserr,$ierr,$f);
  return ($res,$abserr,$ierr);
}



*gslinteg_qagi = \&PDL::GSL::INTEG::gslinteg_qagi;






=head2 gslinteg_qagiu

=for sig

  Signature: (a(); epsabs(); epsrel();int limit();int n();int gslwarn();
		   [o] result(); [o] abserr();int [o] ierr();; SV* function)

=for ref

Adaptive integration on infinite interval

This function estimates the integral of the function f over the
infinite interval (la,+\infty) within the desired absolute and
relative error limits, $epsabs and $epsrel.
After a transformation, the algorithm
of gslinteg_qags with a 15-point Gauss-Kronrod rule is used.
The maximum number of allowed subdivisions done by the adaptive
algorithm must be supplied in the parameter $limit.

=for usage

Usage:

  ($res,$abserr,$ierr) = gslinteg_qagiu($function_ref,$la,$epsabs,
                                        $epsrel,$limit,[{Warn => $warn}]);

=for example

Example:

  my $alfa = 1;
  my ($res,$abserr,$ierr) = gslinteg_qagiu(\&f,99.9,1e-7,0,1000);
  # with warnings on
  ($res,$abserr,$ierr) = gslinteg_qagiu(\&f,99.9,1e-7,0,1000,{Warn => 'y'});

  sub f{
    my ($x) = @_;
    if (($x==0) && ($alfa == 1)) {return 1;}
    if (($x==0) && ($alfa > 1)) {return 0;}
    return ($x**($alfa-1))/((1+10*$x)**2);
  }

=for bad

gslinteg_qagiu does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.

=cut




sub gslinteg_qagiu{
  my $opt = ref($_[-1]) eq 'HASH' ? pop @_ : {Warn => 'n'};
  my $warn = $$opt{Warn}=~/y/i ? 1 : 0;
  my ($f,$la,$epsabs,$epsrel,$limit) = @_;
  barf 'Usage: gslinteg_qagiu($function_ref,$la,$epsabs,$epsrel,$limit,[opt])'
	unless ($#_ == 4);
  $_ = PDL->null for my ($res,$abserr,$ierr);
  _gslinteg_qagiu_int($la,$epsabs,$epsrel,$limit,$limit,$warn,$res,$abserr,$ierr,$f);
  return ($res,$abserr,$ierr);
}



*gslinteg_qagiu = \&PDL::GSL::INTEG::gslinteg_qagiu;






=head2 gslinteg_qagil

=for sig

  Signature: (b(); epsabs(); epsrel();int limit();int n();int gslwarn();
		   [o] result(); [o] abserr();int [o] ierr();; SV* function)

=for ref

Adaptive integration on infinite interval

This function estimates the integral of the function f over the
infinite interval (-\infty,lb) within the desired absolute and
relative error limits, $epsabs and $epsrel.
After a transformation, the algorithm
of gslinteg_qags with a 15-point Gauss-Kronrod rule is used.
The maximum number of allowed subdivisions done by the adaptive
algorithm must be supplied in the parameter $limit.

=for usage

Usage:

  ($res,$abserr,$ierr) = gslinteg_qagl($function_ref,$lb,$epsabs,
                                       $epsrel,$limit,[{Warn => $warn}]);

=for example

Example:

  my ($res,$abserr,$ierr) = gslinteg_qagil(\&myfn,1.0,1e-7,0,1000);
  # with warnings on
  ($res,$abserr,$ierr) = gslinteg_qagil(\&myfn,1.0,1e-7,0,1000,{Warn => 'y'});

  sub myfn{
    my ($x) = @_;
    return exp($x);
  }

=for bad

gslinteg_qagil does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.

=cut




sub gslinteg_qagil{
  my $opt = ref($_[-1]) eq 'HASH' ? pop @_ : {Warn => 'n'};
  my $warn = $$opt{Warn}=~/y/i ? 1 : 0;
  my ($f,$lb,$epsabs,$epsrel,$limit) = @_;
  barf 'Usage: gslinteg_qagil($function_ref,$lb,$epsabs,$epsrel,$limit,[opt])'
	unless ($#_ == 4);
  $_ = PDL->null for my ($res,$abserr,$ierr);
  _gslinteg_qagil_int($lb,$epsabs,$epsrel,$limit,$limit,$warn,$res,$abserr,$ierr,$f);
  return ($res,$abserr,$ierr);
}



*gslinteg_qagil = \&PDL::GSL::INTEG::gslinteg_qagil;






=head2 gslinteg_qawc

=for sig

  Signature: (a(); b(); c(); epsabs(); epsrel();int limit();int n();int gslwarn();
	           [o] result(); [o] abserr();int [o] ierr();; SV* function)

=for ref

Adaptive integration for Cauchy principal values

This function computes the Cauchy principal value of the integral of f over (la,lb),
with a singularity at c, I = \int_{la}^{lb} dx f(x)/(x - c). The integral is
estimated within the desired absolute and relative error limits, $epsabs and $epsrel.
The maximum number of allowed subdivisions done by the adaptive
algorithm must be supplied in the parameter $limit.

=for usage

Usage:

  ($res,$abserr,$ierr) = gslinteg_qawc($function_ref,$la,$lb,$c,$epsabs,$epsrel,$limit)

=for example

Example:

  my ($res,$abserr,$ierr) = gslinteg_qawc(\&f,-1,5,0,0,1e-3,1000);
  # with warnings on
  ($res,$abserr,$ierr) = gslinteg_qawc(\&f,-1,5,0,0,1e-3,1000,{Warn => 'y'});

  sub f{
    my ($x) = @_;
    return 1.0 / (5.0 * $x * $x * $x + 6.0) ;
  }

=for bad

gslinteg_qawc does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.

=cut




sub gslinteg_qawc{
  my $opt = ref($_[-1]) eq 'HASH' ? pop @_ : {Warn => 'n'};
  my $warn = $$opt{Warn}=~/y/i ? 1 : 0;
  my ($f,$la,$lb,$c,$epsabs,$epsrel,$limit) = @_;
  barf 'Usage: gslinteg_qawc($function_ref,$la,$lb,$c,$epsabs,$epsrel,$limit,[opt])'
	unless ($#_ == 6);
  $_ = PDL->null for my ($res,$abserr,$ierr);
  _gslinteg_qawc_int($la,$lb,$c,$epsabs,$epsrel,$limit,$limit,$warn,$res,$abserr,$ierr,$f);
  return ($res,$abserr,$ierr);
}



*gslinteg_qawc = \&PDL::GSL::INTEG::gslinteg_qawc;






=head2 gslinteg_qaws

=for sig

  Signature: (a(); b(); epsabs(); epsrel();int limit();
		 int n(); alpha(); beta(); int mu(); int nu(); int gslwarn();
	         [o] result(); [o] abserr(); int [o] ierr();; SV* function)

=for ref

Adaptive integration for singular functions

The algorithm in gslinteg_qaws is designed for integrands with algebraic-logarithmic
singularities at the end-points of an integration region.
Specifically, this function computes the integral given by
I = \int_{la}^{lb} dx f(x) (x-la)^alpha (lb-x)^beta log^mu (x-la) log^nu (lb-x).
The integral is
estimated within the desired absolute and relative error limits, $epsabs and $epsrel.
The maximum number of allowed subdivisions done by the adaptive
algorithm must be supplied in the parameter $limit.

=for usage

Usage:

  ($res,$abserr,$ierr) =
      gslinteg_qaws($function_ref,$alpha,$beta,$mu,$nu,$la,$lb,
                    $epsabs,$epsrel,$limit,[{Warn => $warn}]);

=for example

Example:

  my ($res,$abserr,$ierr) = gslinteg_qaws(\&f,0,0,1,0,0,1,0,1e-7,1000);
  # with warnings on
  ($res,$abserr,$ierr) = gslinteg_qaws(\&f,0,0,1,0,0,1,0,1e-7,1000,{Warn => 'y'});

  sub f{
    my ($x) = @_;
    if($x==0){return 0;}
    else{
      my $u = log($x);
      my $v = 1 + $u*$u;
      return 1.0/($v*$v);
    }
  }

=for bad

gslinteg_qaws does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.

=cut




sub gslinteg_qaws{
  my $opt = ref($_[-1]) eq 'HASH' ? pop @_ : {Warn => 'n'};
  my $warn = $$opt{Warn}=~/y/i ? 1 : 0;
  my ($f,$alpha,$beta,$mu,$nu,$la,$lb,$epsabs,$epsrel,$limit) = @_;
  barf 'Usage: gslinteg_qaws($function_ref,$alpha,$beta,$mu,$nu,$la,$lb,$epsabs,$epsrel,$limit,[opt])'
	unless ($#_ == 9);
  $_ = PDL->null for my ($res,$abserr,$ierr);
  _gslinteg_qaws_int($la,$lb,$epsabs,$epsrel,$limit,$limit,$alpha,$beta,$mu,$nu,$warn,$res,$abserr,$ierr,$f);
  return ($res,$abserr,$ierr);
}



*gslinteg_qaws = \&PDL::GSL::INTEG::gslinteg_qaws;






=head2 gslinteg_qawo

=for sig

  Signature: (a(); b(); epsabs(); epsrel();int limit();int n();
		 int sincosopt(); omega(); L(); int nlevels();int gslwarn();
	         [o] result(); [o] abserr();int [o] ierr();; SV* function)

=for ref

Adaptive integration for oscillatory functions

This function uses an adaptive algorithm to compute the integral of f over
(la,lb) with the weight function sin(omega*x) or cos(omega*x) -- which of
sine or cosine is used is determined by the parameter $opt ('cos' or 'sin').
The integral is
estimated within the desired absolute and relative error limits, $epsabs and $epsrel.
The maximum number of allowed subdivisions done by the adaptive
algorithm must be supplied in the parameter $limit.

=for usage

Usage:

  ($res,$abserr,$ierr) = gslinteg_qawo($function_ref,$omega,$sin_or_cos,
                                $la,$lb,$epsabs,$epsrel,$limit,[opt])

=for example

Example:

  my $PI = 3.14159265358979323846264338328;
  my ($res,$abserr,$ierr) = PDL::GSL::INTEG::gslinteg_qawo(\&f,10*$PI,'sin',0,1,0,1e-7,1000);
  # with warnings on
  ($res,$abserr,$ierr) = PDL::GSL::INTEG::gslinteg_qawo(\&f,10*$PI,'sin',0,1,0,1e-7,1000,{Warn => 'y'});

  sub f{
    my ($x) = @_;
    if($x==0){return 0;}
    else{ return log($x);}
  }

=for bad

gslinteg_qawo does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.

=cut




sub gslinteg_qawo{
  my $opt = ref($_[-1]) eq 'HASH' ? pop @_ : {Warn => 'n'};
  my $warn = $$opt{Warn}=~/y/i ? 1 : 0;
  my ($f,$omega,$sincosopt,$la,$lb,$epsabs,$epsrel,$limit) = @_;
  barf 'Usage: gslinteg_qawo($function_ref,$omega,$sin_or_cos,$la,$lb,$epsabs,$epsrel,$limit,[opt])'
	unless ($#_ == 7);
  my $OPTION_SIN_COS;
  if($sincosopt=~/cos/i){ $OPTION_SIN_COS = 0;}
  elsif($sincosopt=~/sin/i){ $OPTION_SIN_COS = 1;}
  else { barf("Error in argument 3 of function gslinteg_qawo: specify 'cos' or 'sin'\n");}

  my $L = $lb - $la;
  my $nlevels = $limit;
  $_ = PDL->null for my ($res,$abserr,$ierr);
  _gslinteg_qawo_int($la,$lb,$epsabs,$epsrel,$limit,$limit,$OPTION_SIN_COS,$omega,$L,$nlevels,$warn,$res,$abserr,$ierr,$f);
  return ($res,$abserr,$ierr);
}



*gslinteg_qawo = \&PDL::GSL::INTEG::gslinteg_qawo;






=head2 gslinteg_qawf

=for sig

  Signature: (a(); epsabs();int limit();int n();
		 int sincosopt(); omega(); int nlevels();int gslwarn();
		 [o] result(); [o] abserr();int [o] ierr();; SV* function)

=for ref

Adaptive integration for Fourier integrals

This function attempts to compute a Fourier integral of the function
f over the semi-infinite interval [la,+\infty). Specifically, it attempts
tp compute I = \int_{la}^{+\infty} dx f(x)w(x), where w(x) is sin(omega*x)
or cos(omega*x) -- which of sine or cosine is used is determined by
the parameter $opt ('cos' or 'sin').
The integral is
estimated within the desired absolute error limit $epsabs.
The maximum number of allowed subdivisions done by the adaptive
algorithm must be supplied in the parameter $limit.

=for usage

Usage:

  gslinteg_qawf($function_ref,$omega,$sin_or_cos,$la,$epsabs,$limit,[opt])

=for example

Example:

  my ($res,$abserr,$ierr) = gslinteg_qawf(\&f,$PI/2.0,'cos',0,1e-7,1000);
  # with warnings on
  ($res,$abserr,$ierr) = gslinteg_qawf(\&f,$PI/2.0,'cos',0,1e-7,1000,{Warn => 'y'});

  sub f{
    my ($x) = @_;
    if ($x == 0){return 0;}
    return 1.0/sqrt($x)
  }

=for bad

gslinteg_qawf does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.

=cut




sub gslinteg_qawf{
  my $opt = ref($_[-1]) eq 'HASH' ? pop @_ : {Warn => 'n'};
  my $warn = $$opt{Warn}=~/y/i ? 1 : 0;
  my ($f,$omega,$sincosopt,$la,$epsabs,$limit) = @_;
  barf 'Usage: gslinteg_qawf($function_ref,$omega,$sin_or_cos,$la,$epsabs,$limit,[opt])'
	unless ($#_ == 5);
  my $OPTION_SIN_COS;
  if($sincosopt=~/cos/i){ $OPTION_SIN_COS = 0;}
  elsif($sincosopt=~/sin/i){ $OPTION_SIN_COS = 1;}
  else { barf("Error in argument 3 of function gslinteg_qawf: specify 'cos' or 'sin'\n");}
  my $nlevels = $limit;
  $_ = PDL->null for my ($res,$abserr,$ierr);
  _gslinteg_qawf_int($la,$epsabs,$limit,$limit,$OPTION_SIN_COS,$omega,$nlevels,$warn,$res,$abserr,$ierr,$f);
  return ($res,$abserr,$ierr);
}



*gslinteg_qawf = \&PDL::GSL::INTEG::gslinteg_qawf;







#line 110 "gsl_integ.pd"

=head1 BUGS

Feedback is welcome. Log bugs in the PDL bug database (the
database is always linked from L<http://pdl.perl.org>).

=head1 SEE ALSO

L<PDL>

The GSL documentation for numerical integration is online at
L<https://www.gnu.org/software/gsl/doc/html/integration.html>

=head1 AUTHOR

This file copyright (C) 2003,2005 Andres Jordan <ajordan@eso.org>
All rights reserved. There is no warranty. You are allowed to redistribute
this software documentation under certain conditions. For details, see the file
COPYING in the PDL distribution. If this file is separated from the
PDL distribution, the copyright notice should be included in the file.

The GSL integration routines were written by Brian Gough. QUADPACK
was written by Piessens, Doncker-Kapenga, Uberhuber and Kahaner.

=cut
#line 964 "INTEG.pm"

# Exit with OK status

1;
