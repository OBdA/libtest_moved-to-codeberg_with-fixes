#! /bin/sh

. ./libtest.sh || exit 255

tests 2

pass	'test passed'
fail	'test failed'

TODO messages
pass	'todo test passed'
fail	'todo test failed'

exit 0
#EOF