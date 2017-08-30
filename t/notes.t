# test Notes hash

use strict;
 
use lib "./lib"; 

use File::Spec;
use Test::File;
use Test::More tests => 10;

my @subs = qw(_get_note_xmlfile _get_note_txtfile _get_note_mdpath _get_note_mdfile _get_note_mdtitle _build_notes _build_uldirs);
my @vars = qw($UL_ABS_ROOT_DIR $MD_ABS_ROOT_DIR);

# ADD A BEGIN BLOCK INSURING TEST ONE IS PASSED
use_ok( 'Ulysse', @subs, @vars ) or exit;

$Ulysse::UL_ABS_ROOT_DIR =  File::Spec->rel2abs("t/data/ONE");
file_exists_ok($Ulysse::UL_ABS_ROOT_DIR);

my $xmlnote = File::Spec->catdir($Ulysse::UL_ABS_ROOT_DIR,'0e2d820b5cde4ad5994048e2dbfec2d9-ulgroup/104640f8834643c59eee1c7128be0b8f.ulysses/Content.xml');
file_exists_ok( $xmlnote );
my $txtnote = File::Spec->catdir($Ulysse::UL_ABS_ROOT_DIR,'0e2d820b5cde4ad5994048e2dbfec2d9-ulgroup/104640f8834643c59eee1c7128be0b8f.ulysses/Text.txt');
file_exists_ok( $txtnote );

my $dirnote = 'TEST';
my $pathnote = File::Spec->catdir( $Ulysse::MD_ABS_ROOT_DIR, 'TEST' );
my $mdfile = File::Spec->catdir( $pathnote, 'TEST_0.md');
_build_uldirs();

is ( _build_notes(),1,"Ok : found one note" );
is ( _get_note_xmlfile($xmlnote),$xmlnote,"Ok : first note" );
is ( _get_note_txtfile($xmlnote),$txtnote,"Ok : Text.txt " );
is ( _get_note_mdtitle($xmlnote),'TEST_0.md','OK : md title' );
is ( _get_note_mdpath($xmlnote),$pathnote,'OK : mdpath' );
is ( _get_note_mdfile($xmlnote),$mdfile,'OK : mdfile' );


done_testing;