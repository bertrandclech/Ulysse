use strict;
 
use lib './lib';
use Test::More tests => 2;

my @subs = qw( build_layout );

 
use_ok( 'Ulysse', @subs ) or exit;

can_ok(__PACKAGE__, 'build_layout');


done_testing;