package Andrey;

use Moose;

extends 'Base';

sub get_profile {
	my ($self, $profile_name) = @_;


}
=pod
sub Profiles {

    # Returns an array of profiles as complex data structures. Example profile element:
    #
    # 'profile_name' => {
    #     id       => 5,
    #     name     => 'SomeProfileName',
    #     username => 'bob',
    #     password => 'p@ssw0rd',
    #     hosts => {
    #         'hostname1' => {
    #             ip => '192.168.1.1',
    #             commands = [ 'RTRV-PM-ALL::ALL:CTAG::,,,,1-DAY,,,1;', 'RTRV-PM-1-35::OC48:CTAG::,,,,1-DAY,,,0;', 'RTRV-PM-PREV::OC12:CTAG::,15,,,1-DAY,,,0;' ],
    #         },
    #         'hostname2' => {
    #             ip => '192.168.1.1',
    #             commands = [ 'RTRV-PM-ALL::ALL:CTAG::,,,,1-DAY,,,1;', 'RTRV-PM-1-35::OC48:CTAG::,,,,1-DAY,,,0;', 'RTRV-PM-PREV::OC12:CTAG::,15,,,1-DAY,,,0;' ],
    #         }
    #     },
    # };

    my $self = shift;
    croak "No Database handle available" unless defined( $self->{dbh} );
    my $sth = $self->{dbh}->prepare( 'select distinct(name) from profile order by name' ) || croak "Couldn't prepare statement: " . $self->{dbh}->errstr;
    $sth->execute;
    my $profile_names = $sth->fetchall_arrayref();
    my @profile_names = @$profile_names;
    my $profiles      = [];

    for my $profile_entry ( @profile_names ) {

        my $profile_name = $profile_entry->[ 0 ];

        $sth = $self->{dbh}->prepare( 'select id from profile where name = ?' );
        $sth->execute( $profile_name );
        my ( $profile_id ) = $sth->fetchrow_array();

        $sth = $self->{dbh}->prepare( 'select user_id from profile where id = ?' );
        $sth->execute( $profile_id );
        my ( $user_id ) = $sth->fetchrow_array();

        $sth = $self->{dbh}->prepare( 'select name, password from user where id = ?' );
        $sth->execute( $user_id );
        my ( $username, $password ) = $sth->fetchrow_array();

        my $profile = {
            name     => $profile_name,
            username => $username,
            password => $password,
            hosts    => {},
        };

        $sth = $self->{dbh}->prepare( 'select equipment_id, command_details_id from profile_details where profile_id = ?' );
        $sth->execute( $profile_id );

        while ( my @row = $sth->fetchrow_array ) {
            my ( $host_id, $command_details_id ) = ( $row[ 0 ], $row[ 1 ] );

            my $qry = $self->{dbh}->prepare( 'select ip, name from equipment where id = ?' );
            $qry->execute( $host_id );
            my ( $ip, $host_name ) = $qry->fetchrow_array();

            my $qry2 = $self->{dbh}->prepare( 'select command from command_details where id = ?' );
            $qry2->execute( $command_details_id );
            my ( $command_text ) = $qry2->fetchrow_array();

            $profile->{hosts}{$host_name}{ip} = $ip;
            push @{ $profile->{hosts}{$host_name}{commands} }, $command_text;
        }

        push @$profiles, $profile;
    } ## end for my $profile_entry (...)
    return @$profiles;
} ## end sub Profiles
=cut

no Moose;
__PACKAGE__->meta->make_immutable;

