# test Notes hash

use strict;
 
use lib './lib'; 
use File::Spec;
use Test::File;
use File::HomeDir 'my_home';
use Test::More tests => 7;
##use Ulysse;

my @subs = qw( build_layout _build_notes _build_uldirs );
my @vars = qw($UL_ABS_ROOT_DIR $MD_ABS_ROOT_DIR);

# ADD A BEGIN BLOCK INSURING TEST ONE IS PASSED
use_ok( 'Ulysse', @subs ) or exit;

$Ulysse::UL_ABS_ROOT_DIR =  File::Spec->rel2abs("t/data/ONE");
file_exists_ok($Ulysse::UL_ABS_ROOT_DIR);


my $xmlnote = File::Spec->catdir($Ulysse::UL_ABS_ROOT_DIR,'0e2d820b5cde4ad5994048e2dbfec2d9-ulgroup/104640f8834643c59eee1c7128be0b8f.ulysses/Content.xml');
file_exists_ok( $xmlnote );
my $txtnote = File::Spec->catdir($Ulysse::UL_ABS_ROOT_DIR,'0e2d820b5cde4ad5994048e2dbfec2d9-ulgroup/104640f8834643c59eee1c7128be0b8f.ulysses/Text.txt');
file_exists_ok( $txtnote );


$Ulysse::MD_ABS_ROOT_DIR = File::Spec->catdir(File::HomeDir->my_home, '.Trash');
file_exists_ok($Ulysse::MD_ABS_ROOT_DIR);
unlink ($Ulysse::MD_ABS_ROOT_DIR);

_build_uldirs();
_build_notes();

build_layout();

my $dirnote = 'TEST';
my $mddir = File::Spec->catdir($Ulysse::MD_ABS_ROOT_DIR, $dirnote);
file_exists_ok($mddir);

my $mdfile = File::Spec->catdir($mddir, $dirnote).'_1.md';
file_exists_ok($mdfile);

done_testing;