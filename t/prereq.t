# $Id: prereq.t 1479 2004-09-17 18:09:45Z comdog $
use Test::More;
eval "use Test::Prereq";
plan skip_all => "Test::Prereq required to test dependencies" if $@;
prereq_ok();