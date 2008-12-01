package HTTPx::Dispatcher;
use strict;
use warnings;
use 5.00800;
use base qw/Class::Accessor::Fast/;
our $VERSION = '0.05';
use HTTPx::Dispatcher::Rule;
use Scalar::Util qw/blessed/;
use Carp;

__PACKAGE__->mk_accessors(qw/rules/);

sub new {
    my $class = shift;
    return $class->SUPER::new({ rules => [] });
}

sub add_rule {
    my ( $self, @args ) = @_;
    push @{ $self->rules }, HTTPx::Dispatcher::Rule->new(@args);
}

sub match {
    my ( $self, $req ) = @_;
    croak "request required" unless blessed $req;

    for my $rule ( @{ $self->rules } ) {
        if ( my $result = $rule->match($req) ) {
            return $result;
        }
    }
    return;    # no match.
}

sub uri_for {
    my ( $self, @args ) = @_;

    for my $rule ( @{ $self->rules } ) {
        if ( my $result = $rule->uri_for(@args) ) {
            return $result;
        }
    }
}

1;
__END__

=for stopwords TODO URI uri

=encoding utf8

=head1 NAME

HTTPx::Dispatcher - the uri dispatcher

=head1 SYNOPSIS

    use HTTPx::Dispatcher;
    use HTTP::Engine;
    use UNIVERSAL::require;

    my $dispatcher = HTTPx::Dispatcher->new;

    $dispatcher->add_rule(':controller/:action/:id');

    HTTP::Engine->new(
        'config.yaml',
        handle_request => sub {
            my $c = shift;
            my $rule = $dispatcher->match($c->req);
            $rule->{controller}->use or die 'hoge';
            my $action = $rule->{action};
            $rule->{controller}->$action( $c->req );
        }
    );

=head1 DESCRIPTION

HTTPx::Dispatcher is URI Dispatcher.

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom@gmail.comE<gt>

=head1 THANKS TO

lestrrat

=head1 SEE ALSO

L<HTTP::Engine>,
L<http://api.rubyonrails.org/classes/ActionController/Routing.html>,
L<http://api.rubyonrails.org/classes/ActionController/Routing/RouteSet/Mapper.html>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
