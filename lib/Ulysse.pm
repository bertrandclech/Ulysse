package Ulysse;
 
require Exporter;

our @ISA = qw(Exporter);

use strict;
use warnings;

use base 'Exporter';

use File::Basename qw(fileparse basename);
use File::Find;
use Mac::PropertyList qw(parse_plist_file);
use File::Spec;
use File::Path;
use File::Copy;
use File::HomeDir 'my_home';
use Carp qw( carp croak );
use Capture::Tiny qw( capture );

#our $UL_REL_ROOT_DIR = "Library/Containers/com.soulmen.ulysses3/Data/Library/Application Support/Ulysses/Backups/Latest Backup.ulbackup/Ubiquitous Library.ulstoragebackup/Content";
our $UL_REL_ROOT_DIR;
our $MD_REL_ROOT_DIR = "public/MD";

our $UL_ABS_ROOT_DIR = File::Spec->rel2abs($UL_REL_ROOT_DIR ,File::HomeDir->my_home);
our $MD_ABS_ROOT_DIR = File::Spec->rel2abs($MD_REL_ROOT_DIR ,File::HomeDir->my_home); 

our %UL_DIRS;
our %MD_NOTES; 

our $UL_BACKUP_SEARCH_DIR = File::Spec->rel2abs('Library' ,File::HomeDir->my_home);
our @BACKUPS;

our %EXPORT_TAGS = ( 'all' => [ qw(%UL_DIRS %MD_NOTES _set_backup _get_note_xmlfile _get_note_txtfile _get_note_mdpath _get_note_mdfile _get_note_mdtitle _build_notes _build_uldirs) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw($UL_BACKUP_SEARCH_DIR $UL_REL_ROOT_DIR $MD_REL_ROOT_DIR $UL_ABS_ROOT_DIR $MD_ABS_ROOT_DIR _set_backup build_layout);

our $VERSION = '0.01';


sub _set_backup {
	my $return_status = 0;
	my $cmd = "mdfind -onlyin '$UL_BACKUP_SEARCH_DIR' -name Latest\ Backup.ulbackup -count";	
	my ($stdout, $stderr, $exit) = capture { system($cmd); };	
	if ( ! $exit ) {
		if ( $stdout == 1 ) {   
			$return_status = 1;
			$cmd = "mdfind -onlyin '$UL_BACKUP_SEARCH_DIR' -name Latest\ Backup.ulbackup";
			($stdout, $stderr, $exit) = capture { system($cmd); };
			if ( ! $exit ) {
				$UL_ABS_ROOT_DIR = "$stdout";
				chomp $UL_ABS_ROOT_DIR ;
			}			
		} elsif ( $stdout > 1 ) {  
			carp "Found more than onebackup ... aborting."; # could take more recent
		} else {
			croak "No backup found, aborting !";
		}			
	}	
	return $return_status; 	
}

# wanted sub for searching ulysses dirs
sub _wanted_dirs {
	if ( $_ =~ /^Info.ulgroup$/ ) {
		my ($file,$abs_uldir,$ext) = fileparse($File::Find::name, qr/\.[^.]*/);
		my $ul_curdir = basename($abs_uldir);
		my $plist_data  = parse_plist_file( $_ );
		my $plist_perl  = $plist_data->as_perl;
		my $rec_ulcurdir 				= {};
			$rec_ulcurdir->{ul_dir} 	= $ul_curdir;
			$rec_ulcurdir->{md_dir} 	= $plist_perl->{displayName};
			$rec_ulcurdir->{nb_notes} 	= 0;
		$UL_DIRS{ $rec_ulcurdir->{ul_dir} } = $rec_ulcurdir;	
	}				
}

# Gives the md_dir according to  ulysse dir
sub _get_md_dir {
	my $ul_dir = shift;
	if ( $UL_DIRS{$ul_dir} ) {
		return $UL_DIRS{$ul_dir}->{md_dir};
	}
	else {
		return $ul_dir;
	}
}

# Build the UL_DIRS hash 
sub _build_uldirs {
	find(\&_wanted_dirs, $UL_ABS_ROOT_DIR);
	return scalar keys %UL_DIRS; 
} 

# wanted sub for searching xml ulysses md notes
sub _wanted_notes {
	if ( $_ =~ /Content.xml$/ ) {
		my $mdpath 			= _compute_mdpath();
		my $mdtitle			= basename($mdpath)."_".scalar(keys %MD_NOTES).".md" ; # numbering notes
		my $rec_note 		= {};
			$rec_note->{xmlfile} 	= $File::Find::name;
			$rec_note->{txtfile}	= File::Spec->catfile($File::Find::dir,'Text.txt');
			$rec_note->{mdpath}		= $mdpath;
			$rec_note->{title} 		= $mdtitle;
			$rec_note->{mdfile}		= File::Spec->catfile( $mdpath,$mdtitle ); # missing title 
		$MD_NOTES{ $rec_note->{xmlfile} } = $rec_note;
	}	
}

# Build the MD_NOTES hash 
sub _build_notes {
	find(\&_wanted_notes, $UL_ABS_ROOT_DIR);
	return scalar keys %MD_NOTES;
}

# Compute md path (target) for each md note
sub _compute_mdpath {
	my @dirs = File::Spec->splitdir($File::Find::dir);
	pop @dirs; # pop .ulysses container folder
	# get md dir names for each .ulgroup dir
	foreach my $d ( 0 .. $#dirs ) { # MOD
		splice( @dirs, $d, 1, _get_md_dir($dirs[$d]) );
	}
	return File::Spec->catdir($MD_ABS_ROOT_DIR,  File::Spec->abs2rel( File::Spec->catdir( @dirs ), $UL_ABS_ROOT_DIR ));		 
}

# Build the target layout
sub build_layout {
	if ( _set_backup() ) {
		_build_uldirs();
		_build_notes();
		foreach my $file ( keys %MD_NOTES ) {
			if ( !( -e $MD_NOTES{$file}->{mdpath} ) ) { mkpath( $MD_NOTES{$file}->{mdpath} );}
			copy( $MD_NOTES{$file}->{txtfile},$MD_NOTES{$file}->{mdfile} );
		}	
	}
} 

# Several subs to return hash values for debugging purpose should be no more exported by default
sub _get_note_xmlfile {
	my $key_note = shift;
	return $MD_NOTES{$key_note}->{xmlfile};
}

sub _get_note_txtfile {
	my $key_note = shift;
	return $MD_NOTES{$key_note}->{txtfile};
}

sub _get_note_mdpath {
	my $key_note = shift;
	return $MD_NOTES{$key_note}->{mdpath};
}

sub _get_note_mdfile {
	my $key_note = shift;
	return $MD_NOTES{$key_note}->{mdfile};
}

sub _get_note_mdtitle {
	my $key_note = shift;
	return $MD_NOTES{$key_note}->{title};
}
 
1;
 
=head1 NAME 

Ulysse  - A module to export All the Ulysse Notes as a static layout of Markdown files 
 
=head1 AUTHOR
 
Bertrand Clech L<email:clech@eurecom.fr>
 
=head1 SEE ALSO
 
 
=head1 COPYRIGHT & LICENSE
 
Copyright 2015-2016, Bertrand Clech L<email:clech@eurecom.fr>
 
This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
 
=cut
