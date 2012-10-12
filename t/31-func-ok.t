#! /bin/sh

. ./libtest.sh || exit 255


# prepare the tests
mkdir -p t/tmp
tmp=$(mktemp t/tmp/,XXXXX)
[ -f "$tmp" ] || exit 255


## BEGIN

tests 3

( ./t/data/31-ok.t ) >| $tmp 2>&1
is_status	0	'Tests are all successfull'

is_num $(grep '^#' $tmp|wc -l)		0   'No messages in output'
is_num $(grep '^not' $tmp|wc -l)	0   'No failed tests'

#EOF