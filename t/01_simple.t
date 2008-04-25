use strict;
use warnings;
use Test::Base;
use YAML;
use HTTPx::Dispatcher;
use HTTP::Request;

plan tests => 1*blocks;

filters {
    input    => [qw/yaml _proc/],
    expected => [qw//],
};

run_is input => 'expected';

my $cnt = 1;
sub _proc {
    my ($input, ) = @_;
    my $pkg = "t::Dispatcher::" . ++$cnt;
    eval <<"...";
    package $pkg;
    use HTTPx::Dispatcher;
    $input->{src};
...

    my $method = $input->{method} || 'GET';
    my $res = $pkg->match(HTTP::Request->new($method, $input->{uri}));
    $res = ((not defined $res) ? 'undef' : YAML::Dump($res));
    $res =~ s/^---\n//;
    $res;
}


__END__

===
--- input
src: ''
uri: /
--- expected: undef

===
--- input
src: |+
    connect 'articles/:year/:month' => {
        controller => 'blog',
        action     => 'view',
    };
uri: /articles/2003/10
--- expected
action: view
args:
  month: 10
  year: 2003
controller: blog

===
--- input
src: |+
    connect 'articles/:year/:month' => {
        controller => 'blog',
        action     => 'view',
    };
uri: /articles/2003/10
--- expected
action: view
args:
  month: 10
  year: 2003
controller: blog

===
--- input
src: |+
    connect ':controller/:action/:id';
uri: /user/edit/2
--- expected
action: edit
args:
  id: 2
controller: user

===
--- input
src: |+
    connect 'articles/:year/:month' => {
        controller => 'blog',
        action     => 'view',
        requirements => {
            year  => qr{\d{2,4}},
            month => qr{\d{1,2}},
        }
    };
uri: /articles/2003/10
--- expected
action: view
args:
  month: 10
  year: 2003
controller: blog

===
--- input
src: |+
    connect ':controller/:action-:id'
uri: /user/edit-3
--- expected
action: edit
args:
  id: 3
controller: user

===
--- input
src: |+
    connect 'edit' => {
        conditions => {
            method => 'GET',
        },
        controller => 'user',
        action => 'get_root',
    };
    connect 'edit' => {
        conditions => {
            method => 'POST',
        },
        controller => 'user',
        action => 'post_root',
    };
uri: /edit
method: GET
--- expected
action: get_root
args: {}
controller: user

===
--- input
src: |+
    connect 'edit' => {
        conditions => {
            method => 'GET',
        },
        controller => 'user',
        action => 'get_root',
    };
    connect 'edit' => {
        conditions => {
            method => 'POST',
        },
        controller => 'user',
        action => 'post_root',
    };
uri: /edit
method: POST
--- expected
action: post_root
args: {}
controller: user

=== function condition(1)
--- input
src: |+
    connect 'edit' => {
        conditions => {
            function => sub { $_->method =~ /get/i },
        },
        controller => 'user',
        action => 'get_root',
    };
    connect 'edit' => {
        conditions => {
            function => sub { $_->method =~ /post/i },
        },
        controller => 'user',
        action => 'post_root',
    };
uri: /edit
method: POST
--- expected
action: post_root
args: {}
controller: user

=== function condition(2)
--- input
src: |+
    connect 'edit' => {
        conditions => {
            function => sub { $_->method =~ /get/i },
        },
        controller => 'user',
        action => 'get_root',
    };
    connect 'edit' => {
        conditions => {
            function => sub { $_->method =~ /post/i },
        },
        controller => 'user',
        action => 'post_root',
    };
uri: /edit
method: GET
--- expected
action: get_root
args: {}
controller: user

=== with query
--- input
src: |+
    connect 'articles/:year/:month' => {
        controller => 'blog',
        action     => 'view',
    };
uri: /articles/2003/10?query=foo
--- expected
action: view
args:
  month: 10
  year: 2003
controller: blog
