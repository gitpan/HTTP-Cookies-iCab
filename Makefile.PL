# $Id: Makefile.PL,v 1.7 2007/01/10 04:17:12 comdog Exp $
use ExtUtils::MakeMaker;

eval "use Test::Manifest 1.14";
	
WriteMakefile
	(
	'NAME'           => 'HTTP::Cookies::iCab',
	'VERSION_FROM'   => 'lib/iCab.pm',
	'LICENSE'       => 'perl',
	'PREREQ_PM'      => {
		'HTTP::Cookies'         => '1.25',
		'Test::More'            => '0',
		'Text::Diff'            => '0',
		},
	'PM'             => {
		'lib/iCab.pm' => '$(INST_LIBDIR)/iCab.pm',
		},
	'MAN3PODS'		 => {
		'lib/iCab.pm' => '$(INST_MAN3DIR)/HTTP::Cookies::iCab.3',
		},
	
	clean => { FILES => 'HTTP-Cookies-iCab-*' },
	);

