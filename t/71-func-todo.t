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


err=$( 
	# run without LIBTEST_NO_TODO
	unset LIBTEST_NO_TODO
	t/data/71-todo.t >| $tmp 2>&1 || echo $?
)
is_num ${err:=0} 1	'with TODO: only one test failed'


like_file	$tmp	"^ok.*todo ok # TODO produce success output" \
					'  TODO comment success'

like_file	$tmp	"^not ok.*todo failed # TODO produce failed output" \
					'  TODO comment failed'

like_file	$tmp	"^# +Failed \(TODO\) test 'todo failed'" \
					'  Failed description'

# check for correct file information, aka:
#   Failed (TODO) test 'failed test'
#   in t/data/71-todo.t
err=$(
cat $tmp \
| sed -n "/^#[[:blank:]]*Failed (TODO) test 'todo failed'/ {N;p}" \
| grep -q 'at t/data/71-todo\.t' \
|| echo $?
)
is_num	${err:=0}	0	'  Failed description with file info'


##
##	check TODO_flag
##

err=$(
	# check behaviour with LIBTEST_NO_TODO
	LIBTEST_NO_TODO=1; export LIBTEST_NO_TODO
	t/data/71-todo.t >| $tmp 2>&1 || echo $?
)
is_num	${err:=0}	2	'without TODO: two tests failed'

unlike_file	$tmp	'\(TODO\)' \
					'  no TODO in output'


rm -f $tmp

#EOF
