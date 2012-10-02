#! /bin/sh

. ./libtest.sh || exit 255


##
## BEGIN
##

# prepare the tests
mkdir -p t/tmp
tmp=$(mktemp t/tmp/,nok.XXXXX)
[ -f "$tmp" ] || exit 255


## run the tests

tests 7

# run without LIBTEST_NO_TODO
unset LIBTEST_NO_TODO

( t/data/05-todo.t ) > $tmp 2>&1
is_status	1		'05-todo.t has only one really failed test'


like_file	$tmp	"^ok.*todo ok # TODO produce success output" \
					'TODO comment success'

like_file	$tmp	"^not ok.*todo failed # TODO produce failed output" \
					'TODO comment failed'

like_file	$tmp	"^# +Failed \(TODO\) test 'todo failed'" \
					'  Failed description'

# check for correct file information, aka:
#   Failed (TODO) test 'failed test'
#   in t/data/05-todo.t
cat $tmp \
| grep -E -A 1 		"^# +Failed \(TODO\) test 'todo failed'" \
| grep -q 'at t/data/05-todo\.t'
is_status	0		'  Failed description with file info'


##
##	check TODO_flag
##

TODO working
# check behaviour with LIBTEST_NO_TODO
LIBTEST_NO_TODO=1; export LIBTEST_NO_TODO

( t/data/05-todo.t ) > $tmp 2>&1
is_status	2		'without TODO two tests failed'

unlike_file	$tmp	'\(TODO\)' \
					'no TODO in output'
TODO

rm -f $tmp

#EOF