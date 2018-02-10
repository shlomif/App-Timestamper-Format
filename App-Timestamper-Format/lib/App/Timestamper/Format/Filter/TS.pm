package App::Timestamper::Format::Filter::TS;

use strict;
use warnings;

use App::Timestamper::Filter::TS;

sub new
{
    return bless {}, shift;
}

sub fh_filter
{
    my ($self, $in, $out) = @_;

    my $FMT = $ENV{'TIMESTAMPER_FORMAT'} // '%Y-%m-%d-%H:%M:%S';

    my $filt = App::Timestamper::Filter::TS->new;
    $filt->fh_filter($in,
        sub {
            my ($l) = @_;
            return $out->(
                $l =~ s#\A([0-9\.]+)(\t)#strftime($FMT,localtime($1)).$2#er
            );
        }
    );

    return;
}


1;

=head1 METHODS

=head2 App::Timestamper::Format::Filter::TS->new();

A constructor. Does not accept any options for now.

=head2 $obj->fh_filter($in_filehandle, $out_cb)

Reads line from $in_filehandle until eof() and for each line call $out_cb
with a string containing the timestamp when the line was read, a \t
character and the line itself.

=cut
