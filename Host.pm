package Host;
use feature 'say';
use Moose;

use Types qw/IP/;

extends 'Base';

has 'ip' => (
	is => 'ro',
	isa => IP,
	required => 1,
);

has 'name' => (
    is      => 'ro',
    isa     => 'Str',
	required => 1,
);


#  Fill in with hosts
# has 'hosts' => ();

sub talk {
	my $self = shift;
	say "my ip is: "  . $self->ip;
}

no Moose;
__PACKAGE__->meta->make_immutable;

