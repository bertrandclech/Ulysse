use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Ulysse',
    VERSION_FROM      => 'lib/Ulysse.pm', # finds $VERSION
    EXE_FILES    	  => ['bin/Ulysse'],
    PREREQ_PM         => {
    						'File::Basename' 		=> 2.84,
							'File::Find' 			=> 1.23,
							'Mac::PropertyList' 	=> 1.41,
							'File::Spec' 			=> 3.40,
							'File::Path' 			=> 2.09,
							'File::Copy'			=> 2.26,
							'File::HomeDir' 		=> 1.00,
							'Test::File'			=> 1.44,
						},
#    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Ulysse.pm', # A tool to export Ulysse sheets as MD file keeping layout
       AUTHOR         => 'Bertrand Clech <clech@eurecom.fr>'),
);
