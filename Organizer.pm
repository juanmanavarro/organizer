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

    if(! $self->_check_directory_has_images()) {
        die("No images files in $self->{directory}");
    }

    if(! $self->_confirm()) {
        die();
    }

    # loop files
        # select first file
        # compose destination
            # destination directory (hour)
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

sub _check_directory_has_images {
    my $self = shift;

    my $directory_files_glob = $self->{directory} . "/*.{" . join(',', FILE_EXTENSIONS) . '}';
    my @files = glob( $directory_files_glob );

    return scalar(@files);
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

# sub get_file_dest_directory {
#     my $exifTool = new Image::ExifTool;
#     my $directory_name = 'unknown_date';
#     my $self = shift;

#     my $info = $exifTool->ImageInfo($_);

#     if($info->{CreateDate}) {
#         my ($date, $time) = split(' ', $info->{CreateDate});
#         my @date_components = split(':', $date);

#         $directory_name = join('-', @date_components);
#     }

#     return "$self->{directory}/$directory_name";
# }

1;
