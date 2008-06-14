use inc::Module::Install;
name 'HTTPx-Dispatcher';
all_from 'lib/HTTPx/Dispatcher.pm';

requires 'Class::Accessor::Fast'    => 0.30;
requires 'Exporter'                 => 5.58;
requires 'HTTP::Request'            => 1.40;
requires 'URI'                      => 1.36;

build_requires 'Test::More';
build_requires 'YAML';
build_requires 'Test::MockObject';
use_test_base;
auto_include;
WriteAll;
