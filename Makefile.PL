# $Id: Makefile.PL,v 1.4 2004/09/17 18:09:45 comdog Exp $
use ExtUtils::MakeMaker;

eval "use Test::Manifest";

unless( $@ )
	{
	*ExtUtils::MM_Any::test_via_harness = sub
		{
		my($self, $perl, $tests) = @_;
	
		return qq|\t$perl "-MTest::Manifest" | .
			qq|"-e" "run_t_manifest(\$(TEST_VERBOSE), '\$(INST_LIB)', | .
			qq|'\$(INST_ARCHLIB)')"\n|;
		}
	}
	
WriteMakefile
        (
        'NAME'           => 'HTTP::Cookies::iCab',
		'VERSION'        => '0.91',
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

