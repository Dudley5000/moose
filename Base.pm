package Base;

use DBI;
use Net::Telnet;

use Moose;
use Moose::Util::TypeConstraints;


has 'db_path' => (
	is => 'rw',
	isa => 'Str',
	required => 1,
);

has 'timeout' => (
    is      => 'rw',
    isa     => 'Int',
    default => 20,
);

has 'errmode' => (
    is      => 'rw',
    isa     => enum( [ qw[ die return ] ] ),
    default => 'die',
);

has 'prompt' => (
    is  => 'rw',
    isa => 'Str',
    default => '/< /',
);

has 'db_handle' => (
    is      => 'ro',
    isa     => 'DBI::db',
    builder => '_build_db_handle',
    lazy    => 1,
);

has 'telnet' => (
    is      => 'ro',
    isa     => 'Net::Telnet',
    builder => '_build_telnet',
    lazy    => 1,
);

sub _build_telnet {
    my $self = shift;

    return Net::Telnet->new(
        Timeout => $self->timeout,
        Errmode => $self->errmode,
        Prompt  => $self->prompt,
    );
}

sub _build_db_handle {
    my $self = shift;

    my $dsn = 'dbi:SQLite:' . $self->db_path;
    return DBI->connect( $dsn );
}

no Moose;
__PACKAGE__->meta->make_immutable;

