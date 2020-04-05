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

sub organize {
    my $self = shift;

    if(! $self->_check_directory_exists()) {
        die("$self->{directory} not exists");
    }

    my @files = $self->_get_directory_images();

    if(! scalar(@files)) {
        die("No images files in $self->{directory}");
    }

    if(! $self->_confirm()) {
        die();
    }

    foreach (@files) {
        print "File $_\n";
        my $destination = $self->_get_file_dest_directory($_);
        print "Copy to $destination\n";
        copy($_, $destination) or die "Copy failed: $!";
    }

    # loop files
        # select first file
        # compose destination
            # destination directory (hour)
            # destination name (time)
            # is there a file in the same time?
                # append _1 to filename
                # filename
        # copy to destination
        # delete origin file
    # end loop files
    # exit
}

sub _check_directory_exists {
    my $self = shift;

    return -d $self->{directory};
}

sub _get_directory_images {
    my $self = shift;

    my $directory_files_glob = $self->{directory} . "/*.{" . join(',', FILE_EXTENSIONS) . '}';
    my @files = glob( $directory_files_glob );

    return @files;
}

sub _confirm {
    print "Organize files? [y|n] ";
    my $organize = <STDIN>;
    chomp($organize);

    return $organize eq "y";
}

# sub list_files {
#     my $self = shift;

#     foreach (@files) {
#         # copy("sourcefile", "destinationfile") or die "Copy failed: $!";
#         print $self->get_file_dest_directory($_) . "\n";
#     }

#     print "Total files: " . scalar(@files) . "\n";
# }

sub _get_file_dest_directory {
    my $self = shift;
    my $exifTool = new Image::ExifTool;
    my $full_path = "$self->{directory}/unknown_date";

    my $info = $exifTool->ImageInfo($_);

    if($info->{CreateDate}) {
        my ($date, $time) = split(' ', $info->{CreateDate});
        my @date_components = split(':', $date);

        $full_path = "$self->{directory}/" . join('-', @date_components);

        if(! -d $full_path) {
            mkdir($full_path);
        }
    }

    return "$full_path/" . basename($_);
}

1;
