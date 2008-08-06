# $Id: pod.t 1479 2004-09-17 18:09:45Z comdog $
use Test::More;
eval "use Test::Pod 1.00";
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
all_pod_files_ok();