use strict;
use Test::More tests => 3;

BEGIN {
    use_ok 'HTTPx::Dispatcher';
    use_ok 'HTTPx::Dispatcher::Rule';
    use_ok 'HTTPx::Dispatcher::Declare';
}
