package App::Timestamper::Format;

use 5.014;
use strict;
use warnings;

use IO::Handle;
use Getopt::Long 2.36 qw(GetOptionsFromArray);
use Pod::Usage qw/pod2usage/;

use App::Timestamper::Format::Filter::TS;

sub new
{
    my $class = shift;

    my $self = bless {}, $class;

    $self->_init(@_);

    return $self;
}

sub _init
{
    my ( $self, $args ) = @_;

    my $argv = [ @{ $args->{argv} } ];

    my $help    = 0;
    my $man     = 0;
    my $version = 0;
    if (
        !(
            my $ret = GetOptionsFromArray(
                $argv,
                'help|h' => \$help,
                man      => \$man,
                version  => \$version,
            )
        )
        )
    {
        die "GetOptions failed!";
    }

    if ($help)
    {
        pod2usage(1);
    }

    if ($man)
    {
        pod2usage( -verbose => 2 );
    }

    if ($version)
    {
        print "timestamper version $App::Timestamper::VERSION .\n";
        exit(0);
    }

    $self->{_argv} = $argv;
}

sub run
{
    my ($self) = @_;

    local @ARGV = @{ $self->{_argv} };
    STDOUT->autoflush(1);

    App::Timestamper::Format::Filter::TS->new->fh_filter( \*ARGV,
        sub { print $_[0]; } );

    return;
}

1;

__END__

=encoding utf-8

=head1 NAME

App::Timestamper::Format - prefix lines with formatted timestamps of their arrivals.

=head1 SYNOPSIS

    use App::Timestamper::Format;

    App::Timestamper::Format->new({ argv => [@ARGV] })->run();

=head1 DESCRIPTION

App::Timestamper is a pure-Perl command line program that filters the input
so the formatted timestamps based on the C<TIMESTAMPER_FORMAT> env var are
prefixed to the lines based on the time of the arrival.

So if the input was something like:

    First Line
    Second Line
    Third Line

It will become something like:

    11:12:00\tFirst Line
    11:12:02\tSecond Line
    11:12:04\tThird Line

=head1 SUBROUTINES/METHODS

=head2 new

A constructor. Accepts the argv named arguments.

=head2 run

Runs the program.

=head1 SEE ALSO

L<App::Timestamper> .

=head2 “ts” from “moreutils”

“ts” is a program that is reportedely similar to “timestamper” and
is contained in joeyh’s “moreutils” (see L<http://joeyh.name/code/moreutils/>)
package. It is not easy to find online.

=head2 Chumbawamba’s song “Tubthumping”

I really like the song “Tubthumping” by Chumbawamba, which was a hit during
the 1990s and whose title sounds similar to “Timestamping”, so please check it
out:

=over 4

=item * English Wikipedia Page

L<http://en.wikipedia.org/wiki/Tubthumping>

=item * YouTube Search for the Video

L<http://www.youtube.com/results?search_query=chumbawamba%20tubthumping>

=back

=cut
