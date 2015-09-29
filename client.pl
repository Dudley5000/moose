#!/usr/bin/env perl

use Andrey;
use Host;
use feature 'say';
use Data::Dumper;

local $Data::Dumper::Indent   = 1;
local $Data::Dumper::Sortkeys = 1;

# my $andrey = Andrey->new( db_path => '/home/dudley/Dropbox/andrey/perltestdb123.db' );

my $host = Host->new(
    db_path => '/home/dudley/Dropbox/andrey/perltestdb123.db',
    ip => '216.58.219.78',
    name => 'google.com',    
);

$host->talk;
# my $profile = $andrey->get_profile( 'RTRV-ALM' );

$DB::single = 1;

say 'success';

