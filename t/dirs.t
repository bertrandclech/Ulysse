# test DIRS hash

use strict;
 
use lib "./lib"; 

use File::Spec;
use Test::File;
use Test::More tests => 4; # Without REAL

my @subs = qw(_get_note_xmlfile _get_note_txtfile _get_note_mdpath _get_note_mdfile _get_note_mdtitle _build_notes _build_uldirs);
my @vars = qw($UL_ABS_ROOT_DIR $MD_ABS_ROOT_DIR);

# ADD A BEGIN BLOCK INSURING TEST ONE IS PASSED
use_ok( 'Ulysse', @subs, @vars ) or exit;

$Ulysse::UL_ABS_ROOT_DIR =  File::Spec->rel2abs("t/data/ONE");
file_exists_ok($Ulysse::UL_ABS_ROOT_DIR);
is(_build_uldirs(),1,"Ok : 1 entries for the $Ulysse::UL_ABS_ROOT_DIR"); # OK


$Ulysse::UL_ABS_ROOT_DIR =  File::Spec->rel2abs("t/data/THREE");
is(_build_uldirs(),4,"Ok : 4 entries for the $Ulysse::UL_ABS_ROOT_DIR"); # OK

done_testing;