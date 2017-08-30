# test DIRS hash

use strict;
 
use lib "./lib"; 

use File::Spec;
use Test::File;
use Test::More tests => 6; # Without REAL

my @subs = qw(_set_backup);
my @vars = qw($UL_BACKUP_SEARCH_DIR $UL_ABS_ROOT_DIR);

# ADD A BEGIN BLOCK INSURING TEST ONE IS PASSED
use_ok( 'Ulysse', @subs, @vars ) or exit;

my $dir = $Ulysse::UL_BACKUP_SEARCH_DIR;

##print "debug '$dir'";
file_exists_ok($dir);

file_exists_ok($Ulysse::UL_BACKUP_SEARCH_DIR);
is(_set_backup(),1,"Ok : found a backup file for processing"); # OK
file_exists_ok($Ulysse::UL_ABS_ROOT_DIR);
is( $Ulysse::UL_ABS_ROOT_DIR, '/Users/renesenses/Library/Group Containers/X5AZV975AG.com.soulmen.shared/Ulysses/Backups/Latest Backup.ulbackup', "Ok filename is '$Ulysse::UL_ABS_ROOT_DIR'");

done_testing;