#!/usr/bin/perl -w

use Test::Simple tests => 1;

use strict;
use File::Find::Duplicates;

eval { require File::Temp };

if ($@) {
  ok(1, "No File::Temp ... Skipping test");
} else { 
  File::Temp->import(qw/tempfile tempdir/);
  my $A = "A" x 10000 . "\n";
  my $B = "B" x 1000 . "\n";
  my $C = "C" x 100 . "\n";

  my $dir1 = tempdir(CLEANUP => 1);
  my $dir2 = tempdir(CLEANUP => 1);

  {
    my ($fh1, $name1) = tempfile(DIR => $dir1); print $fh1 $A; 
    my ($fh2, $name2) = tempfile(DIR => $dir1); print $fh2 $A;
    my ($fh3, $name3) = tempfile(DIR => $dir2); print $fh3 $A; 
    my ($fh4, $name4) = tempfile(DIR => $dir1); print $fh4 $B; 
    my ($fh5, $name5) = tempfile(DIR => $dir1); print $fh5 $B;
    my ($fh6, $name6) = tempfile(DIR => $dir1); print $fh6 $C;
  }

  my %dupes = find_duplicate_files($dir1, $dir2); 
  my %dupe_count;
  foreach my $filesize (sort keys %dupes) {
    $dupe_count{scalar @{$dupes{$filesize}}}++;
  }
  ok($dupe_count{3} == 1 && $dupe_count{2} == 1, "Everything found");
}

