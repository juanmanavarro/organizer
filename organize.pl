#!/usr/bin/perl

use strict;
use warnings;

BEGIN { unshift @INC, '.'; }
use Organizer;

my $directory = $ARGV[0] || die('Directory arg is mandatory');

my $organizer = Organizer->new({
    directory => $directory,
});

$organizer->organize();
