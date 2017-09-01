Usage
=====

##AIM OF THE TOOL

This tool creates a full layout of Ulysse notes in markdown format.
It uses the Last Backup performed by Ulysse on user request see UlysseApp Preferences -> Backups

## Usage

After installation, check the Ulysse command is available by typing :
$ which Ulysse
Should return something like
> Ulysse is /usr/local/bin/Ulysse
Then run the Ulysse command
$ Ulysse
If a backup of Ulysse Notes has been performed before, in the user homedir you should see your notes layout in public/MD
$ cd
$ ls public/MD
Should gives something like :
> Boîte pour tout                    Trash-ultrash
> Sur mon Mac                        Ubiquitous Library.ulstoragebackup



##LIMITATIONS

The tool does not deal with several Last Backups files but that should not occur.
