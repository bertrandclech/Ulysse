Ulysse version 0.01
===================

##AIM OF THE TOOL

This tool creates a full layout of Ulysse notes in markdown format.

##REQUIREMENTS

Of course the tool requires a MacOS computer with UlysseApp instaled.  

##DEFAULT VALUES

The Uylsse bin script will create the MD notes layout from user homedir in public/MD folder. ~/public/MD will be created by default
This value can be changed in Ulysse.pm file.  

##INSTALLATION

To install this module type the following:

   perl Makefile.PL
   make
   make test
   make install

##DEPENDENCIES

This module requires these other modules and libraries:
- File::Basename
- File::Find
- Mac::PropertyList
- File::Spec
- File::Path
- File::Copy
- File::HomeDir
- Test::File
- Carp
- Capture::Tiny  

##COPYRIGHT AND LICENCE

Put the correct copyright and licence information here.

Copyright (C) 2016 by Bertrand Clech

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.4 or,
at your option, any later version of Perl 5 you may have available.


