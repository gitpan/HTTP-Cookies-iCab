# $Id: iCab.pm,v 1.4 2004/09/17 18:19:49 comdog Exp $
package HTTP::Cookies::iCab;
use strict;

=head1 NAME

HTTP::Cookies::iCab - Cookie storage and management for iCab

=head1 SYNOPSIS

	use HTTP::Cookies::iCab;

	$cookie_jar = HTTP::Cookies::iCab->new;

	# otherwise same as HTTP::Cookies

=head1 DESCRIPTION

This package overrides the load() and save() methods of HTTP::Cookies
so it can work with iCab cookie files.

See L<HTTP::Cookies>.

=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

	http://sourceforge.net/projects/brian-d-foy/

If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT

Copyright 2003-2004, brian d foy, All rights reserved

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

#/Users/brian/Library/Preferences/iCab Preferences/iCab Cookies
# Time::Local::timelocal(0,0,0,1,0,70)

use base qw( HTTP::Cookies );
use vars qw( $VERSION );

use constant TRUE   => 'TRUE';
use constant FALSE  => 'FALSE';
use constant OFFSET => 2_082_823_200;

$VERSION = sprintf "%2d.%02d", q$Revision: 1.4 $ =~ m/ (\d+) \. (\d+) /xg;

my $Debug = 0;

sub load
	{
    my( $self, $file ) = @_;

    $file ||= $self->{'file'} || return;

    open my $fh, $file or die "Could not open file [$file]: $!";

 	my $size = -s $file;

	COOKIE: until( eof $fh )
		{
		warn "-" x 73, "\n" if $Debug;
		my $set_date = read_date( $fh );
		warn( "\tset date is " . localtime( $set_date ) . "\n" )
			if $Debug;
		my $tag      = read_str( $fh, 4 );
		warn( "==> tag is [$tag] not 'Cook'\n" )
			unless $tag eq 'Cook';

		my $name    = read_var( $fh );
		warn( "\tname is [$name]\n" ) if $Debug;
		my $path    = read_var( $fh );
		warn( "\tpath is [$path]\n" ) if $Debug;
		my $domain  = read_var( $fh );
		warn( "\tdomain is [$domain]\n" ) if $Debug;
		my $value   = read_var( $fh );
		warn( "\tvalue is [$value]\n" ) if $Debug;

		my $expires = read_int( $fh ) - OFFSET;
		warn( "\texpires is " .
			localtime( $expires ) . "\n" ) if $Debug;
		my $str     = read_str( $fh, 7 );

		DATE: {
			my $pos = tell $fh;
			warn( "read $pos of $size bytes\n" ) if $Debug > 1;
			if( eof $fh )
				{
				warn( "Setting cookie [$name]\n" ) if $Debug;
				$self->set_cookie(undef, $name, $value, $path,
					$domain, undef, 0, 0, $expires - time, 0);

				last COOKIE;
				}

			my $peek    = peek( $fh, 12 );
			warn( "\t--peek is $peek\n" ) if $Debug > 1;

			if( substr( $peek, 8, 4 ) eq 'Cook' )
				{
				warn( "Setting cookie [$name]\n" ) if $Debug;
				$self->set_cookie(undef, $name, $value, $path,
					$domain, undef, 0, 0, $expires - time, 0);

				next COOKIE;
				}

			my $date = read_date( $fh );

			redo;
			}


		}


    close $fh;

    1;
	}

sub save
	{
    my( $self, $file ) = @_;

    $file ||= $self->{'file'} || return;

    $self->scan(
    	sub {
			my( $version, $key, $val, $path, $domain, $port,
				$path_spec, $secure, $expires, $discard, $rest ) = @_;

			return if $discard && not $self->{ignore_discard};

			return if time > $expires;

			$expires = do {
				unless( $expires ) { 0 }
				else
					{
					my @times = localtime( $expires );
					$times[5] += 1900;
					$times[4] += 1;

					sprintf "%4d-%02d-%02dT%02d:%02d:%02dZ",
						@times[5,4,3,2,1,0];
					}
				};

			$secure = $secure ? TRUE : FALSE;

			my $bool = $domain =~ /^\./ ? TRUE : FALSE;

	    		}
		);

	open my $fh, "> $file" or die "Could not write file [$file]! $!\n";
    close $fh;
	}

sub read_int
	{
	my $fh = shift;

	my $result = read_str( $fh, 4 );

	my $number = unpack( "I", $result );

	return $number;
	}

sub read_date
	{
	my $fh = shift;

	my $string = read_str( $fh, 4 );
	warn( "\t==tag is [$string] not 'Date'\n" ) unless $string eq 'Date';

	my $date = read_int( $fh );
	warn( sprintf "\t==read date %X | %d | %s\n", $date, $date,
		scalar localtime $date ) if $Debug > 1;

	$date -= OFFSET;
	warn( sprintf "\t==read date %X | %d | %s\n", $date, $date,
		scalar localtime $date ) if $Debug > 1;

	return $date;
	}

sub read_var
	{
	my $fh = shift;

	my $length = read_int( $fh );
	my $string = read_str( $fh, $length );

	return $string;
	}

sub read_str
	{
	my $fh     = shift;
	my $length = shift;

	my $result = read( $fh, my $string, $length );

	return $string;
	}

sub peek
	{
	my $fh     = shift;
	my $length = shift;

	my $result = read( $fh, my $string, $length );

	seek $fh, -$length, 1;

	return $string;
	}
1;
