# $Id: save.t,v 1.1 2003/01/09 03:57:20 comdog Exp $

use Test::More tests => 2;
use Text::Diff;

use HTTP::Cookies::iCab;

my $dist_file = 't/Cookies.dat';
my $save_file = 't/Cookies2.dat';

my %Domains = qw( .cnn.com 1 .usatoday.com 3 );

my $jar = HTTP::Cookies::iCab->new( File => $dist_file );
isa_ok( $jar, 'HTTP::Cookies::iCab' );

my $result = $jar->save( $save_file );

TODO: {
local $TODO = "How can I compare these files?";
my $diff = Text::Diff::diff( $dist_file, $save_file );
my $same = not $diff;
ok( $same, 'Saved file is same as original' );
#print STDERR $diff;
}

#END { unlink $save_file }