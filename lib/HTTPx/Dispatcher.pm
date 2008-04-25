package HTTPx::Dispatcher;
use strict;
use warnings;
use 5.00800;
our $VERSION = '0.01';
use Class::Data::Inheritable;
use HTTPx::Dispatcher::Rule;
use Scalar::Util qw/blessed/;
use Carp;

sub import {
    my $pkg = caller(0);

    no strict 'refs';
    unshift @{"$pkg\::ISA"}, 'Class::Data::Inheritable';
    $pkg->mk_classdata( '__rules' => [] );

    *{"$pkg\::connect"} = sub {
        my @args = @_;
        my $rules = $pkg->__rules;
        push @$rules, HTTPx::Dispatcher::Rule->new(@args);
        $pkg->__rules( $rules );
    };

    *{"$pkg\::match"} = sub {
        my ($class, $req) = @_;
        croak "request required" unless blessed $req;

        for my $rule (@{ $pkg->__rules }) {
            if (my $result = $rule->match($req)) {
                return $result;
            }
        }
        return; # no match.
    };
}

1;
__END__

=for stopwords TODO

=encoding utf8

=head1 NAME

HTTPx::Dispatcher - the uri dispatcher

=head1 SYNOPSIS

    package Your::Dispatcher;
    use HTTPx::Dispatcher;

    connect ':controller/:action/:id';

    package Your::Handler;
    use HTTP::Engine;
    use Your::Dispatcher;
    use UNIVERSAL::require;

    HTTP::Engine->new(
        'config.yaml',
        handle_request => sub {
            my $c = shift;
            my $rule = Your::Dispatcher->match($c->req->uri);
            $rule->{controller}->use or die 'hoge';
            my $action = $rule->{action};
            $rule->{controller}->$action( $c->req );
        }
    );

=head1 DESCRIPTION

HTTPx::Dispatcher is URI Dispatcher.

=head1 TODO

    - dispatch by HTTP::Request.
    - uri_for
    - m.connect(':controller/:(action)-:(id)')

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom@gmail.comE<gt>

=head1 SEE ALSO

L<HTTP::Engine>, L<Routes>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
