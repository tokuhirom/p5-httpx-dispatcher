use inc::Module::Install;
name 'HTTPx-Dispatcher';
all_from 'lib/HTTPx/Dispatcher.pm';

requires 'Class::Accessor::Fast'    => 0.30;
requires 'Exporter'                 => 5.58;
requires 'HTTP::Request'            => 1.40;
requires 'URI'                      => 1.36;

tests 't/*.t t/*/*.t';
recursive_author_tests 'xt';

test_requires 'Test::More';
test_requires 'YAML';
test_requires 'Test::Requires';
auto_set_repository;
use_test_base;
auto_include;
WriteAll;
