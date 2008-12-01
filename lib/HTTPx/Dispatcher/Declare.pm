package HTTPx::Dispatcher::Declare;
use strict;
use warnings;
use HTTPx::Dispatcher;
use Exporter 'import';

our @EXPORT = qw/connect match uri_for dispatcher/;

my $dispatcher = {};
sub dispatcher {
    my $pkg = shift || caller(1);
    return ( $dispatcher->{$pkg} ||= HTTPx::Dispatcher->new );
}

sub connect {
    my @args = @_;
    return dispatcher()->add_rule(@args);
}

sub match {
    my ( $class, $req ) = @_;
    return $class->dispatcher()->match($req);
}

sub uri_for {
    my ( $class, @args ) = @_;
    return $class->dispatcher()->uri_for(@args);
}

1;
__END__

=for stopwords TODO URI uri

=encoding utf8

=head1 NAME

HTTPx::Dispatcher::Declare - declarative dispatcher

=head1 SYNOPSIS

    package Your::Dispatcher;
    use HTTPx::Dispatcher::Declare;

    connect ':controller/:action/:id';

    package Your::Handler;
    use HTTP::Engine;
    use Your::Dispatcher;
    use UNIVERSAL::require;

    HTTP::Engine->new(
        'config.yaml',
        handle_request => sub {
            my $c = shift;
            my $rule = Your::Dispatcher->match($c->req);
            $rule->{controller}->use or die 'hoge';
            my $action = $rule->{action};
            $rule->{controller}->$action( $c->req );
        }
    );

=head1 DESCRIPTION

HTTPx::Dispatcher::Declare is DSL for L<HTTPx::Dispatcher>.

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom@gmail.comE<gt>

=head1 THANKS TO

lestrrat

=head1 SEE ALSO

L<HTTPx::Dispatcher>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
