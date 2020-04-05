package Organizer;

use strict;
use warnings;
use Data::Dumper;
use Image::ExifTool qw(:Public);
use Date::Parse;
use File::Basename;
use File::Copy;

use constant FILE_EXTENSIONS => qw(jpg jpeg png);

sub new {
    my ($class, $args) = @_;

    my $self = bless {
        directory => $args->{directory},
        file_type => $args->{file_type}
    }, $class;
}

sub directory_exists {
    my $self = shift;

    return -d $self->{directory};
}

sub list_files {
    my $self = shift;

    if(! $self->directory_exists()) {
        die("$self->{directory} not exists");
    }

    my $directory_files_glob = $self->{directory} . "/*.{" . join(',', FILE_EXTENSIONS) . '}';

    my @files = glob( $directory_files_glob );
    if(! scalar(@files)) {
        die("No image files in $self->{directory}");
    }

    foreach (@files) {
        # copy("sourcefile", "destinationfile") or die "Copy failed: $!";
        print $self->get_file_dest_directory($_) . "\n";
    }

    print "Total files: " . scalar(@files) . "\n";
}

sub get_file_dest_directory {
    my $exifTool = new Image::ExifTool;
    my $directory_name = 'unknown_date';
    my $self = shift;

    my $info = $exifTool->ImageInfo($_);

    if($info->{CreateDate}) {
        my ($date, $time) = split(' ', $info->{CreateDate});
        my @date_components = split(':', $date);

        $directory_name = join('-', @date_components);
    }

    return "$self->{directory}/$directory_name";
}

sub to_string {
    my $self = shift;
    return "Directory: $self->{directory}\nFile type: $self->{file_type}\n";
}

1;
