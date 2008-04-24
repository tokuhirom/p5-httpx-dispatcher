use strict;
use warnings;
use Test::Base;
use YAML;
use HTTPx::Dispatcher;

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

    my $res = $pkg->match($input->{uri});
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
controller: blog
month: 10
year: 2003

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
controller: blog
month: 10
year: 2003

===
--- input
src: |+
    connect ':controller/:action/:id';
uri: /user/edit/2
--- expected
action: edit
controller: user
id: 2

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
controller: blog
month: 10
year: 2003

