use strict;
 	
use Test::File;
use File::Spec;
use Test::More tests => 1;

my @subs = qw( build_layout );

my $bin = 'bin/Ulysse';

file_executable_ok(File::Spec->rel2abs($bin));


done_testing;

