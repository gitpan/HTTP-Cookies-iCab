# $Id: prereq.t,v 1.2 2004/09/17 18:09:45 comdog Exp $
use Test::More;
eval "use Test::Prereq";
plan skip_all => "Test::Prereq required to test dependencies" if $@;
prereq_ok();