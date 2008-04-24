package HTTPx::Dispatcher::Rule;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;

__PACKAGE__->mk_accessors(qw/re args capture requirements/);

sub new {
    my ($class, $pattern, $args) = @_;
    $args ||= {};
    my $requirements = delete($args->{requirements}) || {};

    my $self = bless { args => $args, requirements => $requirements };

    $self->compile($pattern);
    $self;
}

sub compile {
    my ($self, $pattern) = @_;

    # emulate named capture
    my @capture;
    $pattern =~ s{:([a-z0-9_]+)}{
        push @capture, $1;
        '(.+)'
    }ge;
    $self->re( qr{^$pattern$} );
    $self->capture( \@capture );
}

sub match {
    my ($self, $uri) = @_;

    # articles/:year/:month => qr{articles/(.+)/(.+)}

    if ($uri =~ $self->re) {
        my @last_match_start = @-; # backup perlre vars
        my @last_match_end   = @+;

        my $response = {%{ $self->args }};
        my $requirements = $self->requirements;
        my $cnt      = 1;
        for my $key (@{ $self->capture }) {
            $response->{$key} = substr($uri, $last_match_start[$cnt], $last_match_end[$cnt] - $last_match_start[$cnt]);

            # validate
            # XXX this function needs test.
            if ( exists( $requirements->{$key} )
                && !( $response->{$key} =~ $requirements->{$key} ) )
            {
                die "invalid args: $response->{$key} ( $key ) does not matched $requirements->{$key}";
            }

            $cnt++;
        }
        return $response;
    } else {
        return;
    }
}

1;

