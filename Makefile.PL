# $Id: Makefile.PL,v 1.3 2003/01/09 10:26:15 comdog Exp $
use ExtUtils::MakeMaker;

sub ExtUtils::MM_Any::test_via_harness
		{
		my($self, $perl, $tests) = @_;

		return qq|\t$perl "-MTest::Manifest" | .
			qq|"-e" "run_t_manifest(\$(TEST_VERBOSE), '\$(INST_LIB)', | .
			qq|'\$(INST_ARCHLIB)')"\n|;
		}

WriteMakefile
        (
        'NAME'           => 'HTTP::Cookies::iCab',
#        'VERSION_FROM'   => 'lib/iCab.pm',
		'VERSION'        => '0.90_01',
 		'PREREQ_PM'      => {
 			'File::Find::Rule'      => '0',
 			'HTTP::Cookies'         => '1.25',
 			'Test::Manifest'        => '0.9',
 			'Test::More'            => '0',
 			'Test::Pod'             => '0.72',
 			'Test::Prereq'          => '0.18',
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

