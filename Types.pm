package Types;

use Net::IP::Match::Regexp qw( match_ip create_iprange_regexp );

use Moose;
use MooseX::Types::Moose qw/Str/;
use MooseX::Types -declare => [
    qw(
        IP
        )
];

subtype IP, as Str, where {
    match_ip( $_, create_iprange_regexp( $_ ) )
}, message {
    "IP failed validation";
};
