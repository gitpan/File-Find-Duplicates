package File::Find::Duplicates;

=head1 NAME

File::Find::Duplicates - Find duplicate files

=head1 SYNOPSIS

  use File::Find::Duplicates;

  my %dupes = find_duplicate_files('/basedir1', '/basedir2');

  local $" = "\n  ";
  foreach my $filesize (keys %dupes) {
    print "Duplicate files of size $filesize:\n  @{$dupes{$filesize}}\n";
  }

=head1 DESCRIPTION

This module provides a way of finding duplicate files on your system.

When passed a base directory (or list of such directories) it returns
a hash, keyed on filesize, of lists of the identical files of that size.

=head1 TODO

Check the contents of tars, zipfiles etc to ensure none of these also
exist elsewhere (if so requested).

=head1 SEE ALSO

L<File::Find>.

=head1 AUTHOR

Tony Bowden, E<lt>kasei@tmtm.comE<gt>.

=head1 COPYRIGHT

Copyright (C) 2001 Tony Bowden. All rights reserved.

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use File::Find;
use Digest::MD5;
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA     = qw/Exporter/;
@EXPORT  = qw/find_duplicate_files/;
$VERSION = '0.05';

sub find_duplicate_files {
  my (%dupes, %files);
  find sub {
     -f && push @{$files{(stat(_))[7]}}, $File::Find::name
  }, @_;
  foreach my $size (sort {$b <=> $a} keys %files) {
    next unless @{$files{$size}} > 1;
    my %md5;
    foreach my $file (@{$files{$size}}) {
      open(FILE, $file) or next;
      binmode(FILE);
      push @{$md5{Digest::MD5->new->addfile(*FILE)->hexdigest}},$file;
    }
    foreach my $hash (keys %md5) {
      push @{$dupes{$size}}, @{$md5{$hash}} 
        if (@{$md5{$hash}} > 1);
    }
  }
  return %dupes;
}

return q/
 dissolving ... removing ... there is water at the bottom of the ocean
/;
