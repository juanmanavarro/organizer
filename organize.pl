#!/usr/bin/perl

use strict;
use warnings;

BEGIN { unshift @INC, '.'; }
use Organizer;

my $directory = $ARGV[0] || die('Directory arg is mandatory');
# my $file_type = $ARGV[1] || die('File type is mandatory');

my $organizer = Organizer->new({
    directory => $directory,
    # file_type => $file_type,
});

$organizer->list_files();
