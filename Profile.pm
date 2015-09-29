package Profile;

use Moose;

extends 'Base';

has 'username' => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has 'password' => (
    is      => 'ro',
    isa     => 'Str',
	required => 1,
);


#  Fill in with hosts
has 'hosts' => ();



no Moose;
__PACKAGE__->meta->make_immutable;

