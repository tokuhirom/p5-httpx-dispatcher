use inc::Module::Install;
name 'HTTPx-Dispatcher';
all_from 'lib/HTTPx/Dispatcher.pm';

requires 'Class::Data::Inheritable';
requires 'Class::Accessor::Fast';
requires 'HTTP::Request';
requires 'Exporter' => 5.58;

build_requires 'Test::More';
build_requires 'YAML';
use_test_base;
auto_include;
WriteAll;
